import 'dart:async';

import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:pandora_toolbox/features/source/ui/utils/filesize.dart';

class FileListDisplay extends StatefulWidget {
  final ValueNotifier<FileSystemEntity> selectedNotifier;
  final Stream<File> fileUpdatedStream;

  const FileListDisplay({
    Key? key,
    required this.selectedNotifier,
    required this.fileUpdatedStream,
  }) : super(key: key);

  @override
  _FileListDisplayState createState() => _FileListDisplayState();
}

class _FileListDisplayState extends State<FileListDisplay> {
  late final StreamSubscription<File> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.fileUpdatedStream.listen((file) {
      // Check if the new file is in a subdirectory of the selected directory.
      if (file.uri.normalizePath().path.contains(
          (widget.selectedNotifier.value is Directory
                  ? widget.selectedNotifier.value
                  : widget.selectedNotifier.value.parent)
              .uri
              .normalizePath()
              .path
              .substring(1))) {
        // While the selected directory file hasn't changed, it or it's parent directory has.
        // This has the same effect as a changed selection (widgets need to reload the directory),
        // so a manual notification needs to be dispatched.
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        widget.selectedNotifier.notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  int _readSize(FileSystemEntity entity) {
    var size = entity.statSync().size;
    if (!(entity is Directory)) return size;
    for (final subEntity in entity.listSync(recursive: true)) {
      size += subEntity.statSync().size;
    }
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 2,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: FileListPathBar(
                selectedNotifier: widget.selectedNotifier,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<FileSystemEntity>(
                valueListenable: widget.selectedNotifier,
                builder: (context, selected, _) {
                  final selectedDirectory =
                      selected is Directory ? selected : selected.parent;
                  final selectedDirectoryContents = selectedDirectory.listSync()
                    ..sort((a, b) {
                      if (a is Directory && b is File) return -1;
                      if (b is Directory && a is File) return 1;
                      return a.basename.compareTo(b.basename);
                    });

                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: selectedDirectoryContents.length,
                      itemBuilder: (context, index) {
                        final entity = selectedDirectoryContents[index];
                        return ListTile(
                          selected: selected.basename == entity.basename,
                          leading: Icon(
                            entity is Directory
                                ? Icons.folder_outlined
                                : Icons.insert_drive_file_outlined,
                          ),
                          title: Text(entity.basename),
                          subtitle: Text(filesize(_readSize(entity))),
                          onTap: () => widget.selectedNotifier.value = entity,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileListPathBar extends StatelessWidget {
  final ValueNotifier<FileSystemEntity> selectedNotifier;

  const FileListPathBar({
    Key? key,
    required this.selectedNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FileSystemEntity>(
      valueListenable: selectedNotifier,
      builder: (context, selected, _) {
        final selectedDirectory =
            selected is Directory ? selected : selected.parent;

        final pathSegments = selectedDirectory.path.split('/');

        return IconTheme(
          data: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black45,
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: pathSegments.length,
            separatorBuilder: (context, index) =>
                const Icon(Icons.arrow_forward_ios_outlined),
            itemBuilder: (context, index) {
              final directoryName = pathSegments[index];
              return Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    selectedNotifier.value = (selectedDirectory.fileSystem
                        .directory(
                            pathSegments.sublist(0, index + 1).join('/')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: index == 0
                        ? const Icon(Icons.home_outlined)
                        : Text(
                            directoryName,
                            textScaleFactor: 1.2,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
