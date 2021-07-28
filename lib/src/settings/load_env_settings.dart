import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:console/console.dart';
import 'package:define_env/src/settings/check_env_settings.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';

EnvSettings loadEnvSettings(String envSettingsPath) {
  try {
    var settings = EnvSettings.fromPath(envSettingsPath);
    checkEnvSettingsValid(settings);
    return settings;
  } on ParsedYamlException catch (error) {
    Console.setTextColor(Color.RED.id);
    Console.write(error.formattedMessage);
    exit(-1);
  }
}
