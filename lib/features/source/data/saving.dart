import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter/widgets.dart';
import 'package:pandora_toolbox/core/data/saving.dart';
import 'package:pandora_toolbox/features/downloading/data/patches/jsdoc.dart'
    as patch;
import 'package:pandora_toolbox/features/downloading/data/source.dart';

Stream<String?> saveSources({
  required BuildContext context,
  required FileSystem sourceFs,
  required bool patchJSDoc,
}) async* {
  final overlayFs = MemoryFileSystem();

  if (patchJSDoc) {
    yield 'Patching JSDoc...';
    await patch.patchJSDoc(sourceFs, overlayFs);
  }

  yield 'Zipping sources...';
  final zip = await zipFs(sourceFs, overlayFs);

  yield null;
  saveFile(
    '${getFilenamePrefixFromManifest(context)} sources.zip',
    'application/zip',
    zip,
  );
}
