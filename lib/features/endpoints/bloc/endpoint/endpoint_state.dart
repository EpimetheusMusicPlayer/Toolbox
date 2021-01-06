part of 'endpoint_bloc.dart';

@immutable
class EndpointState {
  final List<EndpointCategory>? endpointCategories;

  const EndpointState(this.endpointCategories);

  const EndpointState.empty() : this(null);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointState &&
          runtimeType == other.runtimeType &&
          endpointCategories == other.endpointCategories;

  @override
  int get hashCode => endpointCategories.hashCode;
}
