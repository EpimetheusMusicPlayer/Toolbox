/// A class representing a Pandora source object.
abstract class SourceNode {
  String path;

  SourceNode(this.path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceNode &&
          runtimeType == other.runtimeType &&
          path == other.path;

  @override
  int get hashCode => path.hashCode;
}

/// A class representing a Pandora source file.
class SourceFile extends SourceNode {
  String contents;

  SourceFile(String path, this.contents) : super(path);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is SourceFile &&
          runtimeType == other.runtimeType &&
          contents == other.contents;

  @override
  int get hashCode => super.hashCode ^ contents.hashCode;
}
