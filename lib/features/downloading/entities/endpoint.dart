/// A class representing a Pandora API endpoint.
class Endpoint {
  final String name;
  final String path;
  final String? notes;

  const Endpoint({
    required this.name,
    required this.path,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'notes': notes,
      };

  @override
  String toString() {
    return 'Endpoint{name: $name, path: $path, notes: $notes}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Endpoint &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          path == other.path &&
          notes == other.notes;

  @override
  int get hashCode => name.hashCode ^ path.hashCode ^ notes.hashCode;
}

/// A class representing an endpoint category.
class EndpointCategory {
  final String? name;
  final List<Endpoint> endpoints;

  const EndpointCategory({
    this.name,
    required this.endpoints,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'endpoints': endpoints,
      };

  @override
  String toString() {
    return 'EndpointCategory{name: $name, endpoints: $endpoints}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndpointCategory &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          endpoints == other.endpoints;

  @override
  int get hashCode => name.hashCode ^ endpoints.hashCode;
}
