library flutter_launcher_name;

import 'dart:io';

import 'package:flutter_launcher_name/android.dart' as android;
import 'package:flutter_launcher_name/constants.dart' as constants;
import 'package:flutter_launcher_name/ios.dart' as ios;
import 'package:flutter_launcher_name/web.dart' as web;
import 'package:yaml/yaml.dart';

exec() {
  print('flutter_launcher_name: Starting to overwrite app names.');

  final config = loadConfigFile();

  final newName = config['name'];

  android.overwriteAndroidManifest(newName);
  print('Finished overwriting Android name.');
  ios.overwriteInfoPlist(newName);
  print('Finished overwriting iOS name.');
  web.overwriteIndexHtmlAndManifest(newName);
  print('Finished overwriting web name.');

  print(
      'flutter_launcher_name: Successfully overwrote names in Android, iOS, and Web.');
}

Map<String, dynamic> loadConfigFile() {
  final File file = File('pubspec.yaml');
  final String yamlString = file.readAsStringSync();
  final Map? yamlMap = loadYaml(yamlString);

  if (yamlMap == null || !(yamlMap[constants.yamlKey] is Map)) {
    throw new Exception('flutter_launcher_name was not found');
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[constants.yamlKey].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}
