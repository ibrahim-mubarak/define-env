import 'package:code_builder/code_builder.dart';
import 'package:define_env/src/library/field_injectors/field_injector.dart';
import 'package:define_env/src/library/library_utils.dart';
import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';
import 'package:recase/recase.dart';

/// Injects the information for the [enum] type field in the env class and library
class EnumFieldInjector extends FieldInjector {
  static const String _valueFieldName = 'value';

  const EnumFieldInjector({
    required FieldEnvSettings fieldSettings,
    required String envFieldName,
  }) : super(
          fieldSettings: fieldSettings,
          envFieldName: envFieldName,
        );

  void onInject(LibraryBuilder lb, ClassBuilder cb, FieldBuilder fb) {
    final enumSettings = fieldSettings.enumSettings!;
    final type = _getFieldType(cb.name!);

    // Injects the enum class into the library
    lb.body.add(Class((b) => b
      ..name = type.symbol
      ..constructors.add(Constructor((b) => b
        ..constant = true
        ..name = '_'
        ..requiredParameters.add(Parameter((b) => b
          ..toThis = true
          ..name = _valueFieldName))))
      ..fields.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..type = stringType
        ..name = _valueFieldName))
      ..fields.addAll(enumSettings.values.map((value) {
        return _createField(type, enumSettings.names[value], value);
      }))
      ..methods.addAll(enumSettings.values.map((value) {
        return _createMethod(enumSettings.names[value], value);
      }))));

    // Injects the remaining field settings into the env class
    fb
      ..type = type
      ..assignment = type.newInstanceNamed('_', [
        stringType.newEnvironmentInstance(
          envFieldName,
          fieldSettings.defaultValue,
        ),
      ]).code;
  }

  /// Create the value field for the enum class
  /// Ex:
  /// class ClassName { ...
  ///   static const ClassName valueName = ClassName._(String.fromEnvironment('VALUE_NAME'))
  Field _createField(
    Reference enumType,
    String? settingsEnumValueName,
    String settingsEnumValue,
  ) {
    final valueName = settingsEnumValueName ?? settingsEnumValue;

    return Field((b) => b
      ..static = true
      ..modifier = FieldModifier.constant
      ..type = enumType
      ..name = valueName
      ..assignment = enumType.newInstanceNamed(
        '_',
        [CodeExpression(valueToCode(settingsEnumValue))],
      ).code);
  }

  /// Create the method to check the value for the enum class
  /// Ex:
  /// class ClassName { ...
  ///   bool get isValueName => this == valueName;
  Method _createMethod(
    String? settingsEnumValueName,
    String settingsEnumValue,
  ) {
    final valueName = settingsEnumValueName ?? settingsEnumValue;

    return Method((b) => b
      ..returns = boolType
      ..type = MethodType.getter
      ..name = 'is${valueName[0].toUpperCase()}${valueName.substring(1)}'
      ..lambda = true
      ..body = Code('this == $valueName'));
  }

  Reference _getFieldType(String envClassName) {
    switch (fieldSettings.type) {
      case FieldTypeEnvSettings.enum$:
        final enumSettings = fieldSettings.enumSettings!;

        if (enumSettings.className != null) {
          return Reference(enumSettings.className!);
        }

        return Reference('${envFieldName.pascalCase}${envClassName}');
      default:
        throw 'Not supported ${fieldSettings.type}';
    }
  }
}
