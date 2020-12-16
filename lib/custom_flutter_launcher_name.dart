library custom_flutter_launcher_name;

import 'dart:io';

import 'package:custom_flutter_launcher_name/android.dart' as android;
import 'package:custom_flutter_launcher_name/constants.dart' as constants;
import 'package:custom_flutter_launcher_name/ios.dart' as ios;
import 'package:yaml/yaml.dart';

exec() {
  print('start');

  final config = loadConfigFile('pubspec.yaml');

  final newName = config['name'];

  android.overwriteAndroidManifest(newName);
  ios.overwriteInfoPlist(newName);

  print('exit');
}

Map<String, dynamic> loadConfigFile(String yamlFileName) {
  File file = File(yamlFileName);

  final String yamlString = file.readAsStringSync();
  final Map yamlMap = loadYaml(yamlString);

  if (yamlMap == null || !(yamlMap[constants.yamlKey] is Map)) {
    if (yamlFileName == '${constants.yamlKey}.yaml')
      throw new Exception('custom_flutter_launcher_name was not found');
    else
      return loadConfigFile('${constants.yamlKey}.yaml');
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap[constants.yamlKey].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}
