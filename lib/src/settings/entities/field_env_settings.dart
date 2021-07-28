import 'package:define_env/src/settings/entities/field_type_env_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'field_env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class FieldEnvSettings {
  final FieldTypeEnvSettings type;
  final Map<String, String?>? enumValues;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  final String? dartName;

  const FieldEnvSettings({
    required this.type,
    required this.enumValues,
    required this.defaultValue,
    required this.dartName,
  });

  factory FieldEnvSettings.fromJson(Map map) => _$FieldEnvSettingsFromJson(map);

  Map<String, dynamic> toJson() => _$FieldEnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';
}
