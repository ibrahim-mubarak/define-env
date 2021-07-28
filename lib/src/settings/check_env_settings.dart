import 'dart:io';

import 'package:console/console.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';

void checkEnvSettingsValid(EnvSettings options) {
  options.fields.forEach((name, fieldOptions) {
    final defaultValue = fieldOptions.defaultValue;
    if (defaultValue == null) return;
    var isFieldValid = _checkSettingsFieldValue(
      "'$name' value in the pubspec",
      fieldOptions.type,
      defaultValue,
      enumValues: fieldOptions.enumValues,
    );
    if (!isFieldValid) {
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
