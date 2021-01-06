import 'package:flutter/material.dart';
import 'package:pandora_toolbox/features/downloading/entities/endpoint.dart';
import 'package:pandora_toolbox/features/endpoints/data/saving.dart';
import 'package:pandora_toolbox/features/endpoints/entities/download_type.dart';

class EndpointDownloadButton extends StatelessWidget {
  final List<EndpointCategory>? endpointCategories;

  const EndpointDownloadButton({
    Key? key,
    required this.endpointCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<EndpointDownloadType>(
      enabled: endpointCategories != null,
      icon: const Icon(Icons.download_sharp),
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: EndpointDownloadType.csv,
          child: Text('CSV'),
        ),
        PopupMenuItem(
          value: EndpointDownloadType.json,
          child: Text('JSON'),
        ),
        PopupMenuItem(
          value: EndpointDownloadType.markdown,
          child: Text('Markdown'),
        ),
      ],
      onSelected: (downloadType) {
        saveEndpoints(
          context: context,
          endpointCategories: endpointCategories!,
          format: downloadType,
        );
      },
    );
  }
}
