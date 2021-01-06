part of 'source_bloc.dart';

@immutable
abstract class SourceState {
  const SourceState();
}

class SourceEmpty extends SourceState {
  const SourceEmpty();
}

class SourceLoading extends SourceState {
  final int loadedModuleCount;
  final int totalModuleCount;

  const SourceLoading(this.loadedModuleCount, this.totalModuleCount);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceLoading &&
          runtimeType == other.runtimeType &&
          loadedModuleCount == other.loadedModuleCount &&
          totalModuleCount == other.totalModuleCount;

  @override
  int get hashCode => loadedModuleCount.hashCode ^ totalModuleCount.hashCode;
}

class SourceLoaded extends SourceState {
  const SourceLoaded();
}
