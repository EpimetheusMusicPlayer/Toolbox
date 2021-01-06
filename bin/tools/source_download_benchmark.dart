import 'package:http/http.dart';
import 'package:pandora_toolbox/features/downloading/data/manifest.dart';
import 'package:pandora_toolbox/features/downloading/data/source.dart';

/// A simple benchmark that can test Pandora source download speeds with
/// different thread counts.
///
/// Documented results (through a VPN):
/// - Chrome:
///   - 4: 7.4
///   - 8: 6.9s
///   - 16: 8.7s
///   - 32: 7.0s
///   - 300: 7.4s
///
/// - macOS:
///   - 4: 16.7s
///   - 8: 9.3s
///   - 16: 5.4s
///   - 32: 3.7s
///   - 300: 3.4s
void main() async {
  const threadCounts = [4, 8, 16, 32, 300];

  final client = Client();

  print('Downloading manifest...');
  final manifest = await fetchManifest(client);

  final stopwatch = Stopwatch();
  Future<void> runBenchmark(int threadCount) async {
    var duration = Duration.zero;
    for (var i = 0; i < 10; ++i) {
      stopwatch.start();
      await downloadManifestSources(client, manifest, threadCount: threadCount)
          .drain();
      stopwatch.stop();
      duration += stopwatch.elapsed;
      print(
          'Thread count $threadCount, round $i: ${stopwatch.elapsedMilliseconds}ms');
      stopwatch.reset();
    }
    print(
        'Average time for $threadCount threads: ${duration.inMilliseconds / 10}ms\n');
  }

  for (final threadCount in threadCounts) {
    await runBenchmark(threadCount);
  }
}
