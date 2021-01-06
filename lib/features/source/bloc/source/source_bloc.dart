import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pandora_toolbox/core/bloc/manifest/manifest_bloc.dart';
import 'package:pandora_toolbox/features/downloading/data/source.dart';
import 'package:pandora_toolbox/features/downloading/entities/manifest.dart';

part 'source_event.dart';
part 'source_state.dart';

class SourceBloc extends Bloc<SourceEvent, SourceState> {
  final Client _client;
  final ManifestBloc _manifestBloc;
  late final StreamSubscription<ManifestState> _manifestBlocSubscription;

  /// A memory filesystem containing source files.
  final MemoryFileSystem sourceFs;

  final _fileUpdatedStreamController = StreamController<File>.broadcast();

  /// A stream broadcasting new files when they're added to the [sourceFs].
  Stream<File> get fileUpdatedStream => _fileUpdatedStreamController.stream;

  SourceBloc._(this._client, this._manifestBloc, this.sourceFs)
      : super(const SourceEmpty()) {
    _manifestBlocSubscription = _manifestBloc.listen((state) {
      if (state is ManifestLoaded) {
        add(SourceLoadRequested(state.manifest));
      }
    });
  }

  SourceBloc(Client client, ManifestBloc manifestBloc)
      : this._(client, manifestBloc, MemoryFileSystem());

  @override
  Future<void> close() {
    _manifestBlocSubscription.cancel();
    return super.close();
  }

  @override
  Stream<SourceState> mapEventToState(
    SourceEvent event,
  ) async* {
    if (event is SourceLoadRequested) {
      final totalModuleCount = event.manifest.moduleCount;
      yield SourceLoading(0, totalModuleCount);
      await for (final sourceFileList in downloadManifestSources(
        _client,
        event.manifest,
      )) {
        for (final sourceFile in sourceFileList) {
          try {
            _fileUpdatedStreamController.add(
              sourceFs.file(sourceFile.path)
                ..createSync(recursive: true)
                ..writeAsStringSync(sourceFile.contents),
            );
          } catch (e) {
            print(e);
            rethrow;
          }
        }
        yield SourceLoading(
            (state as SourceLoading).loadedModuleCount + 1, totalModuleCount);
      }
      yield const SourceLoaded();
    }
  }
}
