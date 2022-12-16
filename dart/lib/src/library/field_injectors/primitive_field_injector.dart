import 'package:code_builder/code_builder.dart';
import 'package:define_env/src/library/field_injectors/field_injector.dart';
import 'package:define_env/src/library/library_utils.dart';
import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';

/// Injects the information for the [String], [int], [bool] type field in the env class
class PrimitiveFieldInjector extends FieldInjector {
  const PrimitiveFieldInjector({
    required FieldEnvSettings fieldSettings,
    required String envFieldName,
  }) : super(
          fieldSettings: fieldSettings,
          envFieldName: envFieldName,
        );

  void onInject(LibraryBuilder lb, ClassBuilder cb, FieldBuilder fb) {
    final type = _getFieldType();

    // Injects the remaining field settings into the env class
    fb
      ..type = type
      ..assignment = type
          .newEnvironmentInstance(envFieldName, fieldSettings.defaultValue)
          .code;
  }

  Reference _getFieldType() {
    switch (fieldSettings.type) {
      case FieldTypeEnvSettings.string:
        return stringType;
      case FieldTypeEnvSettings.bool:
        return boolType;
      case FieldTypeEnvSettings.int:
        return intType;
      default:
        throw 'Not supported ${fieldSettings.type}';
    }
  }
}
