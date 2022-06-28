import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:pandora_toolbox/features/downloading/data/manifest.dart';
import 'package:pandora_toolbox/features/downloading/entities/errors.dart';
import 'package:pandora_toolbox/features/downloading/entities/manifest.dart';

part 'manifest_event.dart';
part 'manifest_state.dart';

class ManifestBloc extends Bloc<ManifestEvent, ManifestState> {
  final Client _client;

  ManifestBloc(this._client) : super(const ManifestLoading()) {
    on<ManifestLoadRequested>((event, emit) async {
      emit(const ManifestLoading());
      try {
        emit(ManifestLoaded(await fetchManifest(_client)));
      } on ManifestNotFoundException {
        emit(const ManifestLoadError(ManifestLoadErrorType.notFound));
      } on DownloadingNetworkException {
        emit(const ManifestLoadError(ManifestLoadErrorType.network));
      }
    });
    add(const ManifestLoadRequested());
  }
}
