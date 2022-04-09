import 'dart:io';

import 'package:flutter_launcher_name/constants.dart' as constants;

/// Updates <title> of index.html; "name" and "short_name" of manifest.json
Future<void> overwriteIndexHtmlAndManifest(String? name) async {
  // update index.html
  final File webIndexHtmlFile = File(constants.webIndexHtmlFile);
  final List<String> indexHtmlLines = await webIndexHtmlFile.readAsLines();

  for (int x = 0; x < indexHtmlLines.length; x++) {
    String line = indexHtmlLines[x];
    if (line.contains('<title>') && line.contains('<\/title>')) {
      indexHtmlLines[x] = "  <title>$name</title>";
    }
  }
  webIndexHtmlFile.writeAsString(indexHtmlLines.join('\n'));

  // update manifest.json
  final File webManifestFile = File(constants.webManifestFile);
  final List<String> webManifestLines = await webManifestFile.readAsLines();

  for (int x = 0; x < webManifestLines.length; x++) {
    String line = webManifestLines[x];
    if (RegExp('"name"\\s*:\\s*".*",\$').hasMatch(line)) {
      webManifestLines[x] = '    "name": "$name",';
    } else if (RegExp('"short_name"\\s*:\\s*".*",\$').hasMatch(line)) {
      webManifestLines[x] = '    "short_name": "$name",';
    }
  }
  webManifestFile.writeAsString(webManifestLines.join('\n'));
}
