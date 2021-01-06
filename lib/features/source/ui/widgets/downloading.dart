import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pandora_toolbox/features/source/bloc/source/source_bloc.dart';
import 'package:pandora_toolbox/features/source/data/saving.dart';

class SourceDownloadButton extends StatelessWidget {
  final FileSystem sourceFs;

  const SourceDownloadButton({
    Key? key,
    required this.sourceFs,
  }) : super(key: key);

  void _showDialog(BuildContext context) async {
    final result = await showDialog<_DialogResult?>(
      context: context,
      builder: (_) => SourceDownloadDialog(),
    );

    if (result == null) return;

    saveSources(
      context: context,
      sourceFs: sourceFs,
      patchJSDoc: result.patchJSDoc,
    ).listen((message) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger == null) return;
      scaffoldMessenger.hideCurrentSnackBar();
      if (message == null) return;
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceBloc, SourceState>(
      builder: (context, state) => IconButton(
        icon: const Icon(Icons.download_sharp),
        onPressed: state is SourceLoaded ? () => _showDialog(context) : null,
      ),
      buildWhen: (previous, current) =>
          !(previous is SourceLoaded) && current is SourceLoaded,
    );
  }
}

class _DialogResult {
  final bool patchJSDoc;

  const _DialogResult({
    required this.patchJSDoc,
  });
}

class SourceDownloadDialog extends StatefulWidget {
  @override
  _SourceDownloadDialogState createState() => _SourceDownloadDialogState();
}

class _SourceDownloadDialogState extends State<SourceDownloadDialog> {
  bool _patchJSDoc = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Download sources'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          CheckboxListTile(
            value: _patchJSDoc,
            onChanged: (value) => setState(() => _patchJSDoc = value!),
            title: const Text('Patch JSDoc'),
            subtitle: const Text(
                'Modifies order of JSDoc directives so documentation generates better'),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          const SizedBox(height: 8),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      actions: [
        OutlineButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        ElevatedButton(
          child: const Text('Download'),
          onPressed: () => Navigator.of(context).pop(
            _DialogResult(patchJSDoc: _patchJSDoc),
          ),
        ),
      ],
    );
  }
}
