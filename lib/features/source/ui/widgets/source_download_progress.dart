import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/features/source/bloc/source/source_bloc.dart';

class SourceDownloadProgress extends StatelessWidget {
  const SourceDownloadProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceBloc, SourceState>(
      buildWhen: (previous, current) =>
          (previous is SourceLoading || previous is SourceEmpty),
      builder: (context, state) {
        if (state is SourceLoaded) return const SizedBox.shrink();
        return Card(
          elevation: 8,
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: state is SourceLoading
                        ? state.loadedModuleCount / state.totalModuleCount
                        : 0,
                  ),
                ),
              ),
              SizedBox(
                width: 256,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Sources are loading...',
                    textScaleFactor: 1.2,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
