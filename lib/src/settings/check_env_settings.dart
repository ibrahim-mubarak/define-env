import 'dart:io';

import 'package:console/console.dart';
import 'package:define_env/define_env.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';

void checkEnvSettingsValid(EnvSettings options) {
  options.fields.forEach((name, fieldOptions) {
    final defaultValue = fieldOptions.defaultValue;

    final isSettingsFieldValid = _checkFieldSettings(name, fieldOptions);

    if (!isSettingsFieldValid) {
      exit(-1);
    }

    if (defaultValue == null) return;

    final isSettingsDefaultFieldValueValid = _checkSettingsDefaultFieldValue(
      name,
      fieldOptions,
      defaultValue,
    );

    if (!isSettingsDefaultFieldValueValid) {
      exit(-1);
    }
  });
}

bool _checkFieldSettings(String name, FieldEnvSettings fieldEnvSettings) {
  switch (fieldEnvSettings.type) {
    case FieldTypeEnvSettings.enum$:
      var enumValues = fieldEnvSettings.enumSettings?.values;
      if (enumValues == null) {
        Console.setTextColor(Color.RED.id);
        Console.write(
          "When you define the field as 'enum', "
          "you must also provide 'enum.values'.",
        );
        return false;
      }

      return true;
    default:
      return true;
  }
}

bool _checkSettingsDefaultFieldValue(
  String name,
  FieldEnvSettings fieldEnvSettings,
  Object? defaultValue,
) {
  switch (fieldEnvSettings.type) {
    case FieldTypeEnvSettings.string:
      if (defaultValue is! String) {
        _writeSettingsTypeError(name, 'String');
        return false;
      }

      return true;
    case FieldTypeEnvSettings.bool:
      if (defaultValue is! bool) {
        _writeSettingsTypeError(name, 'bool');
        return false;
      }

      return true;
    case FieldTypeEnvSettings.int:
      if (defaultValue is! int) {
        _writeSettingsTypeError(name, 'int');
        return false;
      }

      return true;
    case FieldTypeEnvSettings.enum$:
      var enumValues = fieldEnvSettings.enumSettings?.values;
      if (enumValues == null) {
        Console.setTextColor(Color.RED.id);
        Console.write(
          "When you define the field as 'enum', "
          "you must also provide 'enum.values'.",
        );
        return false;
      }

      if (!enumValues.contains(defaultValue)) {
        Console.setTextColor(Color.RED.id);
        Console.write(
          "The '$name.default_value' field is not present in the enum $enumValues",
        );
        return false;
      }

      return true;
  }
}

void _writeSettingsTypeError(String name, String typeName) {
  Console.setTextColor(Color.RED.id);
  Console.write("The '$name.default_value' field is not of '$typeName' type\n");
}
