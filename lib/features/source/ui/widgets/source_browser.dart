import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:pandora_toolbox/features/source/ui/widgets/file_list.dart';
import 'package:pandora_toolbox/features/source/ui/widgets/file_source_display.dart';

/// A source browser.
///
/// The [sources] file system is expected to be a [MemoryFileSystem]; if it's
/// a real filesystem, jank may occur due to synchronous operations in build
/// methods.
class SourceBrowser extends StatefulWidget {
  final FileSystem sources;
  final Stream<File> fileUpdatedStream;

  const SourceBrowser({
    Key? key,
    required this.sources,
    required this.fileUpdatedStream,
  }) : super(key: key);

  @override
  _SourceBrowserState createState() => _SourceBrowserState();
}

class _SourceBrowserState extends State<SourceBrowser> {
  late final _selectedNotifier =
      ValueNotifier<FileSystemEntity>(widget.sources.directory('.'));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: FileListDisplay(
                  selectedNotifier: _selectedNotifier,
                  fileUpdatedStream: widget.fileUpdatedStream,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FileSourceDisplay(
                    selectedNotifier: _selectedNotifier,
                  ),
                ),
              ),
            ],
          );
        } else {
          return ValueListenableBuilder(
            valueListenable: _selectedNotifier,
            builder: (context, entity, _) {
              if (entity is File) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FileSourceDisplay(
                          selectedNotifier: _selectedNotifier,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: FloatingActionButton(
                        child: const Icon(Icons.arrow_back_ios_outlined),
                        onPressed: () => _selectedNotifier.value =
                            _selectedNotifier.value.parent,
                      ),
                    ),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FileListDisplay(
                    selectedNotifier: _selectedNotifier,
                    fileUpdatedStream: widget.fileUpdatedStream,
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
