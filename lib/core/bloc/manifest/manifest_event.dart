part of 'manifest_bloc.dart';

@immutable
abstract class ManifestEvent {
  const ManifestEvent();
}

class ManifestLoadRequested extends ManifestEvent {
  const ManifestLoadRequested();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManifestLoadRequested && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
