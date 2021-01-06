import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/core/widgets/app_app_bar.dart';
import 'package:pandora_toolbox/core/widgets/responsive_builder.dart';
import 'package:pandora_toolbox/features/endpoints/bloc/endpoint/endpoint_bloc.dart';
import 'package:pandora_toolbox/features/endpoints/ui/widgets/download_button.dart';
import 'package:pandora_toolbox/features/endpoints/ui/widgets/endpoint_list.dart';

class EndpointPage extends StatelessWidget {
  static const path = 'endpoints';

  const EndpointPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EndpointBloc, EndpointState>(
      builder: (context, state) {
        return ResponsiveBuilder(
          scaffoldBuilder: (_, drawer, body) {
            return Scaffold(
              appBar: AppAppBar(
                actions: [
                  EndpointDownloadButton(
                    endpointCategories: state.endpointCategories,
                  ),
                ],
              ),
              drawer: drawer,
              body: body,
            );
          },
          bodyBuilder: state.endpointCategories == null
              ? (_, __) => const Center(child: CircularProgressIndicator())
              : (_, __) =>
                  EndpointList(endpointCategories: state.endpointCategories!),
        );
      },
    );
  }
}
