import 'dart:io';

import 'package:console/console.dart';
import 'package:define_env/define_env.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';

void isEnvValid(Map<String, String> envMap, EnvSettings dotEnvOptions) {
  bool isEnvValid =
      dotEnvOptions.fields.entries.fold<bool>(true, (previousValue, element) {
    var name = element.key;
    var fieldOptions = element.value;

    final value = envMap[name];

    if (value == null) {
      bool isDefaultValueValid = _isDefaultValueValid(fieldOptions, name);
      return previousValue && isDefaultValueValid;
    }

    var isEnvFieldValueValid = _isEnvFieldValueValid(
      "'$name' value in the .env",
      fieldOptions.type,
      value,
      enumValues: fieldOptions.enumValues,
    );

    return previousValue && isEnvFieldValueValid;
  });

  if (!isEnvValid) exit(-1);
}

bool _isDefaultValueValid(FieldEnvSettings fieldOptions, String name) {
  if (fieldOptions.defaultValue != null) {
    return true;
  }

  Console.setTextColor(Color.RED.id);
  Console.write(
    "Missing '$name' field on env file or define a 'default' field value\n",
  );
  return false;
}

bool _isEnvFieldValueValid(
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
