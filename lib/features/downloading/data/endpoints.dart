import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:pandora_toolbox/features/downloading/data/source.dart';
import 'package:pandora_toolbox/features/downloading/entities/endpoint.dart';
import 'package:pandora_toolbox/features/downloading/entities/errors.dart';
import 'package:pandora_toolbox/features/downloading/entities/manifest.dart';

/// The path of the source file where the API endpoints are read from.
const endpointSourceFilePath = '/src/constants/ApiActions.ts';

/// Fetches API endpoints.
///
/// Returns list of [EndpointCategory] objects.
Future<List<EndpointCategory>> fetchEndpoints(
  Client client,
  Manifest manifest,
) async {
  final webAppModuleUri = manifest.getModuleJsUri('web-app');
  try {
    final webAppModuleSources = await downloadSources(client, webAppModuleUri);
    final apiActionsSource = webAppModuleSources!
        .firstWhere((sourceFile) => sourceFile.path == endpointSourceFilePath)
        .contents;
    return parseEndpoints(apiActionsSource!);
  } on SocketException {
    throw const DownloadingNetworkException();
  }
}

/// Reads endpoints from an ApiActions.ts file.
List<EndpointCategory> parseEndpoints(String endpointSourceFileContents) {
  final sourceLines = const LineSplitter().convert(endpointSourceFileContents);
  final categories = <EndpointCategory>[];
  var currentCategoryName;
  final currentCategoryEndpoints = <Endpoint>[];

  var isReadingEndpointMap = false;
  for (var i = 0; i < sourceLines.length; ++i) {
    final line = sourceLines[i];
    if (isReadingEndpointMap) {
      if (line.isNotEmpty) {
        if (line.startsWith('}')) {
          isReadingEndpointMap = false;
          break;
        }

        final trimmedLine = line.trim();

        if (trimmedLine.startsWith('//')) {
          categories.add(
            EndpointCategory(
              name: currentCategoryName,
              endpoints: List.of(currentCategoryEndpoints),
            ),
          );
          currentCategoryName = trimmedLine.substring(3);
          currentCategoryEndpoints.clear();
          continue;
        }

        if (line.trim().startsWith('\'')) continue;
        final segments = trimmedLine.split(':');
        if (segments[1].isEmpty) segments[1] = (sourceLines[i + 1]);

        final endpointDescription = segments[1].trim();
        final rhsCommentStartIndex = endpointDescription.indexOf('//');

        String _extractEndpointPath() {
          var output = endpointDescription;
          if (rhsCommentStartIndex != -1) {
            output = output.substring(0, rhsCommentStartIndex).trim();
          }
          output = output.substring(0, output.length - 1).replaceAll('\'', '');

          // Trim again as some endpoints erroneously have whitespace inside the
          // string values
          output = output.trim();

          return output;
        }

        final notes = rhsCommentStartIndex == -1
            ? null
            : endpointDescription
                .substring(rhsCommentStartIndex)
                .trim()
                .substring(2)
                .trim();

        currentCategoryEndpoints.add(
          Endpoint(
            name: segments[0],
            path: _extractEndpointPath(),
            notes: notes == 'cspell' ? null : notes,
          ),
        );
      }
    } else {
      if (line.startsWith('export const ApiEndpoints')) {
        isReadingEndpointMap = true;
      }
    }
  }

  return categories;
}
