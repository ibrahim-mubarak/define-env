import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class EnvSettings {
  final Map<String, FieldEnvSettings> fields;

  EnvSettings({
    required this.fields,
  });

  factory EnvSettings.fromJson(Map<dynamic, dynamic> map) => _$EnvSettingsFromJson(map);
  Map<dynamic, dynamic> toJson() => _$EnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';
}
