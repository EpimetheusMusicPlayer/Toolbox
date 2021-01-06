part of 'source_bloc.dart';

@immutable
abstract class SourceEvent {
  const SourceEvent();
}

class SourceLoadRequested extends SourceEvent {
  final Manifest manifest;

  const SourceLoadRequested(this.manifest);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceLoadRequested &&
          runtimeType == other.runtimeType &&
          manifest == other.manifest;

  @override
  int get hashCode => manifest.hashCode;
}
