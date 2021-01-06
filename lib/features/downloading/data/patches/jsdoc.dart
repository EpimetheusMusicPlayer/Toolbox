import 'package:file/file.dart';

/// This function patches JSDoc in a source filesystem to generate documentation
/// better.
///
/// [destFs] can be the same filesystem as [sourceFs]. If [destFs] differs, only
/// modified files will be put into it.
///
/// [threadCount] determines the maximum amount of files being patched and
/// written at once.
Future<void> patchJSDoc(FileSystem sourceFs, FileSystem destFs) async {
  final futures = <Future<void>>[];
  for (final entity in sourceFs.directory('/').listSync(recursive: true)) {
    if (!(entity is File &&
        (entity.path.endsWith('.js') ||
            entity.path.endsWith('.ts') ||
            entity.path.endsWith('.jsx') ||
            entity.path.endsWith('.tsx')))) continue;

    futures.add(_fixJsdoc(entity, destFs.file(entity.path)));
  }
  await Future.wait(futures);
}

/// Some files have the description declared above the module declaration, which
/// doesn't work. This function fixes that by moving them below the module
/// declaration.
int? _fixDescriptionPosition(
  List<String> fileContents,
  int originalModuleLineNumber,
) {
  // Count the number of description lines above the module declaration.
  var preDescriptionLineCount = 0;
  while (true) {
    ++preDescriptionLineCount;

    var previousLine =
        fileContents[originalModuleLineNumber - preDescriptionLineCount];
    if (previousLine == '/**') {
      --preDescriptionLineCount;
      break;
    }
  }

  // Return null if there's nothing to fix.
  if (preDescriptionLineCount == 0) return null;

  // Move everything down.
  final moduleLine = fileContents[originalModuleLineNumber];
  for (var i = preDescriptionLineCount - 1; i >= 0; --i) {
    final originalLineIndex =
        originalModuleLineNumber - (preDescriptionLineCount - i);
    fileContents[originalLineIndex + 1] = fileContents[originalLineIndex];
  }

  // Calculate the new module line number.
  final newModuleLineNumber =
      originalModuleLineNumber - preDescriptionLineCount;

  // The module line was overwritten; write it above the description.
  fileContents[newModuleLineNumber] = moduleLine;

  // Remove blank lines at the end.
  if (fileContents[originalModuleLineNumber] == ' *') {
    fileContents.removeAt(originalModuleLineNumber);
  }

  return newModuleLineNumber;
}

/// Some module names end in an extension, which jsdoc doesn't like.
/// This function removes the suffix.
bool _fixModuleName(
  List<String> fileContents,
  int moduleLineNumber,
) {
  final moduleLine = fileContents[moduleLineNumber];
  final moduleName = moduleLine.split('@module ').last;

  if (moduleName.endsWith('.js') || moduleName.endsWith('.ts')) {
    fileContents[moduleLineNumber] =
        moduleLine.substring(0, moduleLine.length - 3);
    return true;
  } else if (moduleName.endsWith('.jsx') || moduleName.endsWith('.tsx')) {
    fileContents[moduleLineNumber] =
        moduleLine.substring(0, moduleLine.length - 4);
    return true;
  }

  return false;
}

/// Module descriptions are missing the @description jsdoc tag.
/// This function adds the tags in.
///
/// A quirk where there are sometimes two comment line prefixes ("*") is also
/// taken care of.
bool _fixDescriptionDeclaration(
  List<String> fileContents,
  int moduleLineNumber,
) {
  // Look at the next line.
  var lineIndex = moduleLineNumber + 1;
  var line = fileContents[lineIndex];

  // If the next line isn't a comment, or it's the end of a comment, stop.
  if (!line.startsWith(' *')) return false;
  if (line.contains(' */')) return false;

  // If the line is a blank comment, look at the next one.
  if (line == ' *') {
    ++lineIndex;
    line = fileContents[lineIndex];
    if (line.contains(' */')) return false;
  }

  // Stop here if there's already a description tag.
  if (fileContents[lineIndex].startsWith(' * @description ')) {
    return false;
  }

  // Write the line, prefixed by the proper tag.
  fileContents[lineIndex] = ' * @description ${line.replaceFirst(
        ' * ',
        '',
      ).replaceFirst(
        ' * ',
        '',
      )}';

  return true;
}

Future<void> _fixJsdoc(File sourceFile, File destFile) async {
  final fileContents = await sourceFile.readAsLines();
  var contentsModified = false;

  var i = 0;
  while (true) {
    if (i == fileContents.length) break;

    if (fileContents[i].startsWith(' * @module ')) {
      // The module line may be changed by a fix, so record the original.
      final originalModuleLine = i;

      // Fix the description position. See the method docs for more info.
      i = _fixDescriptionPosition(fileContents, i) ?? i;
      contentsModified = (i != originalModuleLine) || contentsModified;

      // Fix the module name. See the method docs for more info.
      contentsModified = _fixModuleName(fileContents, i) || contentsModified;

      // Fix the module description declaration. See the method docs for more info.
      contentsModified =
          _fixDescriptionDeclaration(fileContents, i) || contentsModified;

      /// Patch specific issue in webpack/src/lib/Social/FacebookService.js
      if (sourceFile.path.contains('lib/Social/FacebookService.js') &&
          fileContents[i].contains(' * * ')) {
        fileContents[i] = fileContents[i].substring(3);
      }
    }

    ++i;
  }

  // Save the file if it changed.
  if (contentsModified) {
    final directory = destFile.parent;
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    await destFile.writeAsString(fileContents.join('\n') + '\n');
  }
}
