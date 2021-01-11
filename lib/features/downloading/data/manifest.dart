import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:jsparser/jsparser.dart';
import 'package:pandora_toolbox/features/downloading/data/source.dart';
import 'package:pandora_toolbox/features/downloading/data/uris.dart';
import 'package:pandora_toolbox/features/downloading/entities/errors.dart';
import 'package:pandora_toolbox/features/downloading/entities/manifest.dart';
import 'package:universal_html/html.dart' hide Client;
import 'package:universal_html/parsing.dart';

/// Fetches a manifest including module and root scripts.
Future<Manifest> fetchManifest(Client client) async {
  try {
    final manifestMap = <String, String>{};

    // Download the website HTML.
    // Always use the CORS proxy here as it's also a good geo-block bypass.
    final pandoraWebsiteResponse = await client.get(pandoraWebCorsUrl);
    final pandoraWebsiteBody = pandoraWebsiteResponse.body;
    final pandoraWebsiteHtml = parseHtmlDocument(pandoraWebsiteResponse.body);

    // Read the Web app version from the "assetHost" path declaration in a script.
    final version = RegExp(r'\/web-version\/(.*)\/')
            .firstMatch(pandoraWebsiteBody)
            ?.group(1) ??
        '?.???.?';

    // Find root JS files, and add them to the manifest map.
    // Also find the manifest script URL for later.
    String? manifestUrl;
    pandoraWebsiteHtml.body!.children
        .whereType<ScriptElement>()
        .where(
          (element) => element.src.startsWith(
            'https://web-cdn.pandora.com/web-client-assets/',
          ),
        )
        .forEach(
      (rootScript) {
        final url = rootScript.src;
        final filename = url.substring(46);
        final segments = filename.split('.');
        final name = segments[0];
        if (name == 'manifest') manifestUrl = url;
        // The ads script has nothing in it and is CORS protected. Ignore it.
        if (!kIsWeb || name != 'ads') {
          manifestMap[name] = segments[1];
        }
      },
    );

    if (manifestUrl == null) throw const ManifestNotFoundException();

    // Download manifest JavaScript.
    final manifestJs = parsejs(
      (await downloadSources(client, Uri.parse(manifestUrl!)))![0].contents,
      handleNoise: false,
      annotations: false,
    );

    // Extract module info and add the modules to the manifest map.
    final manifestReturnExpression = ((((((manifestJs.body.singleWhere(
                        (statement) =>
                            statement is FunctionDeclaration &&
                            statement.function.name.value == 'jsonpScriptSrc')
                    as FunctionDeclaration)
                .function
                .body) as BlockStatement)
            .body
            .first) as ReturnStatement)
        .argument as BinaryExpression);

    final sourceNames = {
      for (final property
          in ((((((manifestReturnExpression.left as BinaryExpression).left
                                  as BinaryExpression)
                              .left as BinaryExpression)
                          .right as BinaryExpression)
                      .left as IndexExpression)
                  .object as ObjectExpression)
              .properties)
        (property.key as LiteralExpression).value:
            (property.value as LiteralExpression).value,
    };

    final sourceSuffixes = {
      for (final property
          in (((manifestReturnExpression.left as BinaryExpression).right
                      as IndexExpression)
                  .object as ObjectExpression)
              .properties)
        (property.key as LiteralExpression).value:
            (property.value as LiteralExpression).value,
    };

    for (final index in sourceNames.keys) {
      manifestMap[sourceNames[index]] = sourceSuffixes[index];
    }

    return Manifest(version, manifestMap);
  } on SocketException {
    throw const DownloadingNetworkException();
  }
}
