/// A class holding path information about all Pandora source files.
///
/// Generated from a combination of the Pandora root webpage HTML and the
/// webpack module loading code.
class Manifest {
  /// The version of the Pandora Web app.
  final String appVersion;

  /// The current Web app config.
  final Map<String, dynamic> config;

  /// A map of JavaScript module names to suffixes.
  final Map<String, String> _moduleData;

  const Manifest(this.appVersion, this.config, this._moduleData);

  int get moduleCount => _moduleData.length;

  Iterable<String> get moduleNames => _moduleData.keys;

  Uri getModuleJsUri(String moduleName) {
    assert(_moduleData.containsKey(moduleName), 'Invalid module name!');
    return Uri(
      scheme: 'https',
      host: 'web-cdn.pandora.com',
      path: 'web-client-assets/${moduleName}.${_moduleData[moduleName]!}.js',
    );
  }

  Iterable<Uri> get moduleJsUris =>
      _moduleData.keys.map((moduleName) => getModuleJsUri(moduleName));

  @override
  String toString() => 'Manifest{appVersion: $appVersion}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Manifest &&
          runtimeType == other.runtimeType &&
          appVersion == other.appVersion &&
          config == other.config &&
          _moduleData == other._moduleData;

  @override
  int get hashCode =>
      appVersion.hashCode ^ config.hashCode ^ _moduleData.hashCode;
}
