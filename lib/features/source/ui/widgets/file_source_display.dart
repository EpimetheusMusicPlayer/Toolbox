import 'dart:ui';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/idea.dart';
import 'package:pandora_toolbox/features/source/ui/utils/map_ext.dart';

class FileSourceDisplay extends StatelessWidget {
  static late final _lightTheme = Map<String, TextStyle>.from(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  static late final _darkTheme = Map<String, TextStyle>.from(darculaTheme)
    ..['root'] =
        darculaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final ValueNotifier<FileSystemEntity> selectedNotifier;

  const FileSourceDisplay({
    Key? key,
    required this.selectedNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder(
      valueListenable: selectedNotifier,
      builder: (context, selected, _) {
        if (!(selected is File)) {
          return Center(
            child: Icon(
              Icons.folder_open_rounded,
              color: isDarkTheme ? Colors.white24 : const Color(0x10000000),
              size: 256,
            ),
          );
        }
        final extDot = selected.path.lastIndexOf('.');
        final ext =
            extDot == -1 ? '' : mapExt(selected.path.substring(extDot + 1));
        return Scrollbar(
          child: SingleChildScrollView(
            child: HighlightView(
              selected.readAsStringSync(),
              language: ext,
              theme: isDarkTheme ? _darkTheme : _lightTheme,
              textStyle: const TextStyle(
                fontFamily: 'JetBrains Mono',
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        );
      },
    );
  }
}
