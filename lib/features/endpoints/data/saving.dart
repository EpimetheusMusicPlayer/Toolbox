import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pandora_toolbox/core/data/saving.dart';
import 'package:pandora_toolbox/features/downloading/entities/endpoint.dart';
import 'package:pandora_toolbox/features/endpoints/entities/download_type.dart';

void saveEndpoints({
  required BuildContext context,
  required List<EndpointCategory> endpointCategories,
  required EndpointDownloadType format,
}) {
  final baseFileName = '${getFilenamePrefixFromManifest(context)} endpoints';

  switch (format) {
    case EndpointDownloadType.csv:
      saveFile(
        '$baseFileName.csv',
        'text/csv',
        utf8.encode(_encodeCsv(endpointCategories)),
      );
      break;
    case EndpointDownloadType.json:
      saveFile(
        '$baseFileName.json',
        'application/json',
        utf8.encode(_encodeJson(endpointCategories)),
      );
      break;
    case EndpointDownloadType.markdown:
      saveFile(
        '$baseFileName.md',
        'text/markdown',
        utf8.encode(_encodeMarkdown(endpointCategories)),
      );
      break;
  }
}

String _encodeCsv(List<EndpointCategory> endpointCategories) {
  final buffer = StringBuffer('Name/Category,Path,Notes\n');
  for (final category in endpointCategories) {
    buffer.writeln();
    buffer.writeln(category.name ?? 'Uncategorized');
    for (final endpoint in category.endpoints) {
      buffer.write('"');
      buffer.write(endpoint.name);
      buffer.write('","');
      buffer.write(endpoint.path);
      buffer.write('"');
      if (endpoint.notes != null) {
        buffer.write(',"');
        buffer.write(endpoint.notes);
        buffer.write('"');
      }
      buffer.writeln();
    }
  }
  return buffer.toString();
}

String _encodeJson(List<EndpointCategory> endpointCategories) =>
    const JsonEncoder.withIndent('  ').convert(endpointCategories);

String _encodeMarkdown(List<EndpointCategory> endpointCategories) {
  final buffer = StringBuffer(
      '<!--- Endpoints dumped by Pandora Toolbox by hacker1024 -->\n');
  for (final category in endpointCategories) {
    buffer.writeln('### ${category.name ?? 'Uncategorized'}');
    buffer.writeln('|Name|Path|Notes|');
    buffer.writeln('|---:|:---|:----|');
    for (final endpoint in category.endpoints) {
      buffer.writeln(
          '|${endpoint.name}|${endpoint.path}|${endpoint.notes ?? ''}|');
    }
  }
  return buffer.toString();
}
