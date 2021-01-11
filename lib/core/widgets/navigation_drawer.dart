import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/core/bloc/manifest/manifest_bloc.dart';
import 'package:pandora_toolbox/features/config/ui/pages/config_page.dart';
import 'package:pandora_toolbox/features/endpoints/ui/pages/endpoint_page.dart';
import 'package:pandora_toolbox/features/home/ui/pages/home_page.dart';
import 'package:pandora_toolbox/features/source/ui/pages/source_page.dart';

class NavigationDrawer extends StatelessWidget {
  static const items = [
    DrawerItem(
      iconData: Icons.home_outlined,
      label: 'Home',
      path: HomePage.path,
    ),
    DrawerItem(
      iconData: Icons.list_outlined,
      label: 'Endpoint list',
      path: EndpointPage.path,
    ),
    DrawerItem(
      iconData: Icons.settings,
      label: 'Configuration',
      path: ConfigPage.path,
    ),
    DrawerItem(
      iconData: Icons.code_outlined,
      label: 'Source code',
      path: SourcePage.path,
    ),
  ];

  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPath = ModalRoute.of(context)!.settings.name;
    return Drawer(
      elevation: 8,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final item in items)
                  ListTile(
                    leading: Icon(item.iconData),
                    title: Text(item.label),
                    selected: item.path == currentPath,
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed(item.path),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: BlocBuilder<ManifestBloc, ManifestState>(
              builder: (context, state) {
                if (state is ManifestLoading) {
                  return const ListTile(
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    ),
                    title: Text('Loading manifest...'),
                  );
                } else if (state is ManifestLoaded) {
                  return ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(
                        'Inspecting Pandora Web ${state.manifest.appVersion}'),
                  );
                } else {
                  const color = Colors.red;
                  return const ListTile(
                    leading: Icon(
                      Icons.error_outline,
                      color: color,
                    ),
                    title: Text(
                      'Error loading manifest!',
                      style: TextStyle(color: color),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem {
  final IconData iconData;
  final String label;
  final String path;

  const DrawerItem({
    required this.iconData,
    required this.label,
    required this.path,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawerItem &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          label == other.label &&
          path == other.path;

  @override
  int get hashCode => iconData.hashCode ^ label.hashCode ^ path.hashCode;
}
