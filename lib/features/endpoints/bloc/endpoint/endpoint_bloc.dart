import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file/file.dart';
import 'package:meta/meta.dart';
import 'package:pandora_toolbox/features/downloading/data/endpoints.dart';
import 'package:pandora_toolbox/features/downloading/entities/endpoint.dart';

part 'endpoint_event.dart';
part 'endpoint_state.dart';

class EndpointBloc extends Bloc<EndpointEvent, EndpointState> {
  late final StreamSubscription<File> _sourceFileSubscription;

  EndpointBloc(Stream<File> sourceFileStream)
      : super(const EndpointState.empty()) {
    _sourceFileSubscription = sourceFileStream.listen((file) {
      if (file.path == endpointSourceFilePath) {
        add(EndpointSourcesLoaded(file.readAsStringSync()));
      }
    });
  }

  @override
  Future<void> close() {
    _sourceFileSubscription.cancel();
    return super.close();
  }

  @override
  Stream<EndpointState> mapEventToState(EndpointEvent event) async* {
    if (event is EndpointSourcesLoaded) {
      yield EndpointState(parseEndpoints(event.endpointSourceFileContents));
    }
  }
}
