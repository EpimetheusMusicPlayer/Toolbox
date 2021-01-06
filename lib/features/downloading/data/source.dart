import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:batcher/batcher.dart';
import 'package:file/file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pandora_toolbox/features/downloading/entities/errors.dart';
import 'package:pandora_toolbox/features/downloading/entities/manifest.dart';
import 'package:pandora_toolbox/features/downloading/entities/source_file.dart';
import 'package:source_maps/parser.dart';

/// Downloads sources from a minified JavaScript file URI.
///
/// Completes with null if an unrecognised mapping format is detected.
Future<List<SourceFile>?> downloadSources(Client client, Uri jsUri) async {
  final sourceMappingUri = jsUri.replace(path: jsUri.path + '.map');
  try {
    final sourceMapping = parseJson(
      jsonDecode((await client.get(sourceMappingUri)).body),
      mapUrl: sourceMappingUri,
    );

    if (!(sourceMapping is SingleMapping)) return null;

    return [
      for (var i = 0; i < sourceMapping.urls.length; ++i)
        SourceFile(
          Uri.parse(sourceMapping.urls[i]).normalizePath().path,
          sourceMapping.files[i]!.getText(0),
        )
    ];
  } on SocketException {
    throw const DownloadingNetworkException();
  }
}

Stream<List<SourceFile>> downloadManifestSources(
  Client client,
  Manifest manifest, {
  int threadCount = 32,
}) {
  // TODO handle potential cases where [downloadSources] returns `null` due to
  // an unrecognised source map format. This doesn't happen at the moment, but
  // it could change.
  return manifest.moduleJsUris
      .map((jsUri) => () => downloadSources(client, jsUri))
      .streamBatch(threadCount)
      .where((sourceFileList) => sourceFileList != null)
      .cast();
}

/// Asynchronously creates a ZIP archive from a filesystem.
///
/// If [overlayFs] is provided, files with the same paths as files in [fs] will
/// replace the files from [fs].
///
/// Note: This is not yet truly asynchronous on the Web.
/// https://github.com/flutter/flutter/issues/33577
Future<List<int>> zipFs(FileSystem fs, [FileSystem? overlayFs]) async {
  final archive = Archive();
  final files = fs
      .directory('/')
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .toList(growable: false);
  if (overlayFs != null) {
    for (var i = 0; i < files.length; ++i) {
      final overlayFile = overlayFs.file(files[i].path);
      if (overlayFile.existsSync()) files[i] = overlayFile;
    }
  }
  await Future.wait([
    for (final file in files)
      file.readAsBytes().then((content) => archive
          .addFile(ArchiveFile.noCompress(file.path, content.length, content))),
  ]);
  return await compute<Archive, List<int>>(_zipCallback, archive);
}

List<int> _zipCallback(Archive archive) {
  return ZipEncoder().encode(archive, level: Deflate.NO_COMPRESSION)!;
}
