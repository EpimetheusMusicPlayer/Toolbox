import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/idea.dart';

class SourceDisplay extends StatefulWidget {
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
  State<SourceDisplay> createState() => _SourceDisplayState();
}

class _SourceDisplayState extends State<SourceDisplay> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controller,
      child: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: HighlightView(
            widget.contents,
            language: widget.language,
            theme: Theme.of(context).brightness == Brightness.dark
                ? SourceDisplay._darkTheme
                : SourceDisplay._lightTheme,
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
