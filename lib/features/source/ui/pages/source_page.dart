import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/core/widgets/app_app_bar.dart';
import 'package:pandora_toolbox/core/widgets/responsive_builder.dart';
import 'package:pandora_toolbox/features/source/bloc/source/source_bloc.dart';
import 'package:pandora_toolbox/features/source/ui/widgets/downloading.dart';
import 'package:pandora_toolbox/features/source/ui/widgets/source_browser.dart';
import 'package:pandora_toolbox/features/source/ui/widgets/source_download_progress.dart';

class SourcePage extends StatelessWidget {
  static const path = 'source_code';

  const SourcePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SourceBloc>(context);
    return ResponsiveBuilder(
      scaffoldBuilder: (_, drawer, body) {
        return Scaffold(
          appBar: AppAppBar(
            actions: [
              SourceDownloadButton(
                sourceFs: bloc.sourceFs,
              ),
            ],
          ),
          drawer: drawer,
          body: body,
        );
      },
      bodyBuilder: (_, drawerExpanded) {
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Stack(
            children: [
              Positioned.fill(
                child: SourceBrowser(
                  sources: bloc.sourceFs,
                  fileUpdatedStream: bloc.fileUpdatedStream,
                ),
              ),
              const Positioned(
                bottom: 16,
                right: 16,
                child: SourceDownloadProgress(),
              ),
            ],
          ),
        );
      },
    );
  }
}
