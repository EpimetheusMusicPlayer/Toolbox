import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/core/bloc/manifest/manifest_bloc.dart';
import 'package:universal_html/html.dart';
import 'package:url_launcher/url_launcher.dart';

String getFilenamePrefixFromManifest(BuildContext context) {
  final manifestState = BlocProvider.of<ManifestBloc>(context).state;
  final version = manifestState is ManifestLoaded
      ? manifestState.manifest.appVersion
      : '?.???.?';
  return 'Pandora Web $version';
}

void saveFile(String name, String mime, List<int> bytes) {
  if (kIsWeb) {
    // On the web, creates a blob resource, adds a hidden download link to the
    // DOM, and clicks it.
    final blob = Blob([bytes], mime);
    final blobUrl = Url.createObjectUrlFromBlob(blob);
    final anchor = document.createElement('a') as AnchorElement
      ..href = blobUrl
      ..style.display = 'none'
      ..download = name;
    document.body!.children.add(anchor);
    anchor.click();
    document.body!.children.remove(anchor);
    Url.revokeObjectUrl(blobUrl);
  } else {
    // On other platforms, just open a base64 URI.
    // This is primarily a web app; this functionality exists to allow
    // debugging on other platforms.
    launch('data:$mime;base64,${base64.encode(bytes)}', forceSafariVC: false);
  }
}
