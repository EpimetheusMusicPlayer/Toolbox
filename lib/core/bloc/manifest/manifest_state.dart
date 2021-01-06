part of 'manifest_bloc.dart';

@immutable
abstract class ManifestState {
  const ManifestState();
}

class ManifestLoading extends ManifestState {
  const ManifestLoading();
}

class ManifestLoaded extends ManifestState {
  final Manifest manifest;

  const ManifestLoaded(this.manifest);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManifestLoaded &&
          runtimeType == other.runtimeType &&
          manifest == other.manifest;

  @override
  int get hashCode => manifest.hashCode;
}

class ManifestLoadError extends ManifestState {
  final ManifestLoadErrorType type;

  const ManifestLoadError(this.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManifestLoadError &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}

enum ManifestLoadErrorType { notFound, network }
