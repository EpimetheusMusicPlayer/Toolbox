import 'package:flutter/material.dart';

class AppAppBar extends AppBar {
  AppAppBar({
    Key? key,
    List<Widget>? actions,
  }) : super(
          title: const Text('Pandora Toolbox by hacker1024'),
          actions: actions,
        );
}
