import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/idea.dart';

class SourceDisplay extends StatelessWidget {
  static late final _lightTheme = Map<String, TextStyle>.from(ideaTheme)
    ..['root'] =
        ideaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  static late final _darkTheme = Map<String, TextStyle>.from(darculaTheme)
    ..['root'] =
        darculaTheme['root']!.copyWith(backgroundColor: Colors.transparent);

  final String language;
  final String contents;

  const SourceDisplay({
    Key? key,
    required this.language,
    required this.contents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: HighlightView(
            contents,
            language: language,
            theme: Theme.of(context).brightness == Brightness.dark
                ? _darkTheme
                : _lightTheme,
            textStyle: const TextStyle(
              fontFamily: 'JetBrains Mono',
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
