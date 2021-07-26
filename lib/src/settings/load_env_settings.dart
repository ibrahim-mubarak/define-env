import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:console/console.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';

EnvSettings? loadEnvSettings(String envSettingsPath) {
  final envSettingsFile = _loadEnvSettingsContents(envSettingsPath);
  if (envSettingsFile == null) return null;

  try {
    return checkedYamlDecode(
      envSettingsFile.readAsStringSync(),
      (yamlMap) {
        if (yamlMap == null) return null;
        final defineEnvMap = yamlMap['define_env'];
        if (defineEnvMap == null) return null;
        return EnvSettings.fromJson(defineEnvMap);
      },
      sourceUrl: Uri.file(envSettingsFile.path),
    );
  } on ParsedYamlException catch (error) {
    Console.setTextColor(Color.RED.id);
    Console.write(error.formattedMessage);
    exit(-1);
  }
}

File? _loadEnvSettingsContents(String envSettingsPath) {
  final defineEnvFile = File(envSettingsPath);
  if (defineEnvFile.existsSync()) {
    return defineEnvFile;
  }
  var pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    return pubspecFile;
  }
  return null;
}
