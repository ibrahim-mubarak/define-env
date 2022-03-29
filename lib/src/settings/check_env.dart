import 'dart:io';

import 'package:console/console.dart';
import 'package:define_env/define_env.dart';
import 'package:dotenv/dotenv.dart';

void isEnvValid(DotEnv dotEnv, EnvSettings envSettings) {
  bool isEnvValid =
      envSettings.fields.entries.fold<bool>(true, (previousValue, element) {
    final name = element.key;
    final value = dotEnv[name];
    final fieldOptions = element.value;

    if (value == null) {
      bool isDefaultValueValid = _isDefaultValueValid(fieldOptions, name);
      return previousValue && isDefaultValueValid;
    }

    var isEnvFieldValueValid = _isEnvFieldValueValid(name, fieldOptions, value);
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
  FieldEnvSettings fieldSettings,
  String value,
) {
  switch (fieldSettings.type) {
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
      var enumValues = fieldSettings.enumSettings!.values;
      if (!enumValues.contains('$value')) {
        Console.setTextColor(Color.RED.id);
        Console.write(
          "The '$name' value in the .env file is not present in the enum $enumValues",
        );
        return false;
      }

      return true;
  }
}

void _writeEnvTypeError(String name, String typeName) {
  Console.setTextColor(Color.RED.id);
  Console.write(
    "The '$name' field in the .env file is not of the '$typeName' type\n",
  );
}
