import 'package:flutter/material.dart';
import 'package:pandora_toolbox/core/widgets/navigation_drawer.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Scaffold Function(BuildContext context, Widget? drawer, Widget body)
      scaffoldBuilder;
  final Widget Function(BuildContext context, bool drawerExpanded) bodyBuilder;

  const ResponsiveBuilder({
    Key? key,
    required this.scaffoldBuilder,
    required this.bodyBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawer = const NavigationDrawer();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 850 ||
            constraints.maxWidth < constraints.maxHeight) {
          return scaffoldBuilder(context, drawer, bodyBuilder(context, false));
        }

        return scaffoldBuilder(
          context,
          null,
          Row(
            children: [
              SizedBox(width: 300, child: drawer),
              Expanded(child: bodyBuilder(context, true)),
            ],
          ),
        );
      },
    );
  }
}
