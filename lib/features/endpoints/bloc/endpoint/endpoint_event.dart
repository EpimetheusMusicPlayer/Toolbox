part of 'endpoint_bloc.dart';

@immutable
abstract class EndpointEvent {
  const EndpointEvent();
}

class EndpointSourcesLoaded extends EndpointEvent {
  final String endpointSourceFileContents;

  const EndpointSourcesLoaded(this.endpointSourceFileContents);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointSourcesLoaded &&
          runtimeType == other.runtimeType &&
          endpointSourceFileContents == other.endpointSourceFileContents;

  @override
  int get hashCode => endpointSourceFileContents.hashCode;
}
// class EndpointLoadRequested extends EndpointEvent {
//   final Manifest manifest;
//
//   const EndpointLoadRequested(this.manifest);
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is EndpointLoadRequested &&
//           runtimeType == other.runtimeType &&
//           manifest == other.manifest;
//
//   @override
//   int get hashCode => manifest.hashCode;
// }
