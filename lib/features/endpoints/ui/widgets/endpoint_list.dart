import 'package:flutter/material.dart';
import 'package:pandora_toolbox/features/downloading/entities/endpoint.dart';

class EndpointList extends StatelessWidget {
  final List<EndpointCategory> endpointCategories;

  const EndpointList({
    Key? key,
    required this.endpointCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        for (final category in endpointCategories)
          EndpointCategoryDisplay(category: category),
      ],
    );
  }
}

class EndpointCategoryDisplay extends StatelessWidget {
  final EndpointCategory category;

  const EndpointCategoryDisplay({
    Key? key,
    required this.category,
  }) : super(key: key);

  String get subtitle =>
      category.endpoints.length.toString() +
      (category.endpoints.length == 1 ? ' endpoint' : ' endpoints');

  @override
  Widget build(BuildContext context) {
    const labelPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
    const verticalEndsPaddingRow = TableRow(
      children: [
        SizedBox(height: 4),
        SizedBox(height: 4),
        SizedBox(height: 4),
      ],
    );

    Widget _padLabel(Widget label) =>
        Padding(padding: labelPadding, child: label);

    return ExpansionTile(
      key: PageStorageKey(category),
      title: Text(category.name ?? 'Uncategorized'),
      subtitle: Text(subtitle),
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            verticalEndsPaddingRow,
            TableRow(
              children: [
                _padLabel(const Text(
                  'Path',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                _padLabel(const Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                _padLabel(const Text(
                  'Notes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              ],
            ),
            for (final endpoint in category.endpoints)
              TableRow(
                children: [
                  _padLabel(
                    Text(
                      endpoint.path,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  _padLabel(
                    Text(
                      endpoint.name,
                    ),
                  ),
                  _padLabel(
                    Text(
                      endpoint.notes ?? '',
                    ),
                  ),
                ],
              ),
            verticalEndsPaddingRow,
          ],
        ),
      ],
    );
  }
}
