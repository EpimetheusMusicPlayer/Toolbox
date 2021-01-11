import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/core/bloc/manifest/manifest_bloc.dart';
import 'package:pandora_toolbox/core/widgets/app_app_bar.dart';
import 'package:pandora_toolbox/core/widgets/responsive_builder.dart';
import 'package:pandora_toolbox/core/widgets/source_display.dart';
import 'package:pandora_toolbox/features/config/data/saving.dart';

class ConfigPage extends StatelessWidget {
  static const path = 'config';

  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManifestBloc, ManifestState>(
      buildWhen: (previous, current) =>
          (!(previous is ManifestLoaded) && current is ManifestLoaded) ||
          (!(current is ManifestLoaded) && previous is ManifestLoaded),
      builder: (context, state) {
        return ResponsiveBuilder(
          scaffoldBuilder: (_, drawer, body) {
            return Scaffold(
              appBar: AppAppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download_sharp),
                    onPressed: state is ManifestLoaded
                        ? () => saveConfig(
                              context,
                              state.manifest.config,
                              2,
                            )
                        : null,
                  ),
                ],
              ),
              drawer: drawer,
              body: body,
            );
          },
          bodyBuilder: (context, _) {
            if (!(state is ManifestLoaded)) {
              return Center(child: const CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SourceDisplay(
                language: 'json',
                contents: const JsonEncoder.withIndent('  ')
                    .convert(state.manifest.config),
              ),
            );
          },
        );
      },
    );
  }
}
