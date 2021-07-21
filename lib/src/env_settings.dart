import 'package:json_annotation/json_annotation.dart';

part 'env_settings.g.dart';

enum FieldTypeEnvSettings {
  @JsonValue('String')
  string,
  bool,
  int,
  @JsonValue('enum')
  enum$,
}

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

  factory FieldEnvSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$FieldEnvSettingsFromJson(map);
  Map<dynamic, dynamic> toJson() => _$FieldEnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';
}

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class EnvSettings {
  final Map<String, FieldEnvSettings> fields;

  EnvSettings({
    required this.fields,
  });

  factory EnvSettings.fromJson(Map<dynamic, dynamic> map) =>
      _$EnvSettingsFromJson(map);
  Map<dynamic, dynamic> toJson() => _$EnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';
}
