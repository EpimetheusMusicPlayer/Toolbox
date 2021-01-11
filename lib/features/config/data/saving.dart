import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pandora_toolbox/core/data/saving.dart';

void saveConfig(BuildContext context, Map<String, dynamic> config, int indent) {
  saveFile(
    '${getFilenamePrefixFromManifest(context)} configuration.json',
    'application/json',
    JsonEncoder.withIndent(' ' * indent).fuse(utf8.encoder).convert(config),
  );
}
