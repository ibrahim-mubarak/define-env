import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:console/console.dart';
import 'package:define_env/src/env_settings.dart';

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

void checkEnvSettings(EnvSettings options) {
  options.fields.forEach((name, fieldOptions) {
    final defaultValue = fieldOptions.defaultValue;
    if (defaultValue == null) return;
    if (!_checkSettingsFieldValue(
      "'$name' value in the pubspec",
      fieldOptions.type,
      defaultValue,
      enumValues: fieldOptions.enumValues,
    )) {
      exit(-1);
    }
  });
}

bool _checkSettingsFieldValue(
  String name,
  FieldTypeEnvSettings type,
  Object value, {
  Map<String, String?>? enumValues,
}) {
  switch (type) {
    case FieldTypeEnvSettings.string:
      if (value is! String) {
        _writeSettingsTypeError(name, 'String');
        return false;
      }
      return true;
    case FieldTypeEnvSettings.bool:
      if (value is! bool) {
        _writeSettingsTypeError(name, 'bool');
        return false;
      }
      return true;
    case FieldTypeEnvSettings.int:
      if (value is! int) {
        _writeSettingsTypeError(name, 'int');
        return false;
      }
      return true;
    case FieldTypeEnvSettings.enum$:
      if (enumValues == null) {
        Console.setTextColor(Color.RED.id);
        Console.write(
            "When you define the field with 'enum' field type in pubspec.yaml file you must also define the 'enum_values' field with enum values.");
        return false;
      }
      if (!enumValues.containsKey(value)) {
        Console.setTextColor(Color.RED.id);
        Console.write(
            "The '$name.default_value' field in the pubspec.yaml file is not present in the enum ${enumValues.keys.toList()}");
        return false;
      }
      return true;
  }
}

void _writeSettingsTypeError(String name, String typeName) {
  Console.setTextColor(Color.RED.id);
  Console.write(
      "The '$name.default_value' field in the pubspec.yaml file is not of the '$typeName' type");
}

void checkEnv(Map<String, String> envMap, EnvSettings dotEnvOptions) {
  bool isValid = true;
  dotEnvOptions.fields.forEach((name, fieldOptions) {
    final value = envMap[name];
    if (value == null) {
      if (fieldOptions.defaultValue == null) {
        Console.setTextColor(Color.RED.id);
        Console.write(
            "Missing '$name' field on env file or define a 'default' field value");
        isValid = false;
        return;
      }
      // Validation not required
      return;
    }
    if (!_checkEnvFieldValue(
      "'$name' value in the .env",
      fieldOptions.type,
      value,
      enumValues: fieldOptions.enumValues,
    )) {
      isValid = false;
      return;
    }
  });
  if (!isValid) exit(-1);
}

bool _checkEnvFieldValue(
  String name,
  FieldTypeEnvSettings type,
  String value, {
  Map<String, String?>? enumValues,
}) {
  switch (type) {
    case FieldTypeEnvSettings.string:
      return true;
    case FieldTypeEnvSettings.bool:
      if (!const ['true', 'false'].contains(value)) {
        _writeEnvTypeError(name, 'bool');
        return false;
      }
      return true;
    case FieldTypeEnvSettings.int:
      if (int.tryParse(value) == null) {
        _writeEnvTypeError(name, 'int');
        return false;
      }
      return true;
    case FieldTypeEnvSettings.enum$:
      if (!enumValues!.containsKey('$value')) {
        Console.setTextColor(Color.RED.id);
        Console.write(
            "The value in the .env file is not present in the enum ${enumValues.keys.toList()}");
        return false;
      }
      return true;
  }
}

void _writeEnvTypeError(String name, String typeName) {
  Console.setTextColor(Color.RED.id);
  Console.write(
      "The '$name' field in the .env file is not of the '$typeName' type");
}
