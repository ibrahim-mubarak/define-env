import 'package:define_env/src/settings/entities/enum_env_settings.dart';
import 'package:define_env/src/settings/entities/field_type_env_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'field_env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class FieldEnvSettings {
  /// The type of the field in the env
  final FieldTypeEnvSettings type;

  /// The settings of the type enum.
  /// They are only required if the enum type is used
  @JsonKey(name: 'enum')
  final EnumEnvSettings? enumSettings;

  /// The default value used in dart when the value in the environment is missing
  @JsonKey(name: 'default')
  final Object? defaultValue;

  /// The name of the field in the env class in dart
  final String? fieldName;

  const FieldEnvSettings({
    required this.type,
    required this.enumSettings,
    required this.defaultValue,
    required this.fieldName,
  });

  factory FieldEnvSettings.fromJson(Map map) => _$FieldEnvSettingsFromJson(map);

  Map<String, dynamic> toJson() => _$FieldEnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';
}
