import 'package:json_annotation/json_annotation.dart';

part 'enum_env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class EnumEnvSettings {
  /// Class name of the enum in dart
  @JsonKey(name: 'class')
  final String? className;

  /// List of enum values, cannot be repeated
  final List<String> values;

  /// Maps with the key the value of the enum in the env and
  /// with the value the name in the dart class
  final Map<String, String> names;

  const EnumEnvSettings({
    required this.className,
    required this.values,
    this.names = const {},
  });

  factory EnumEnvSettings.fromJson(Map map) => _$EnumEnvSettingsFromJson(map);

  Map<String, dynamic> toJson() => _$EnumEnvSettingsToJson(this);
}
