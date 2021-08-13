import 'package:code_builder/code_builder.dart';
import 'package:define_env/src/library/field_injectors/enum_field_injector.dart';
import 'package:define_env/src/library/field_injectors/primitive_field_injector.dart';
import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';
import 'package:recase/recase.dart';

/// Injects the field settings into the library or env class
abstract class FieldInjector {
  final FieldEnvSettings fieldSettings;
  final String envFieldName;

  const FieldInjector({
    required this.fieldSettings,
    required this.envFieldName,
  });

  factory FieldInjector.from(
    FieldEnvSettings fieldSettings,
    String envFieldName,
  ) {
    switch (fieldSettings.type) {
      case FieldTypeEnvSettings.enum$:
        return EnumFieldInjector(
          fieldSettings: fieldSettings,
          envFieldName: envFieldName,
        );
      default:
        return PrimitiveFieldInjector(
          fieldSettings: fieldSettings,
          envFieldName: envFieldName,
        );
    }
  }

  void inject(LibraryBuilder lb, ClassBuilder cb) {
    cb.fields.add(Field((b) => b
      ..static = true
      ..modifier = FieldModifier.constant
      ..name = fieldSettings.fieldName ?? envFieldName.camelCase
      ..update((fb) => onInject(lb, cb, fb))));
  }

  void onInject(LibraryBuilder lb, ClassBuilder cb, FieldBuilder fb);
}
