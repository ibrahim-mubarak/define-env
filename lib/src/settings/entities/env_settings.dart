import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class EnvSettings {
  final Map<String, FieldEnvSettings> fields;

  EnvSettings({
    required this.fields,
  });

  factory EnvSettings.fromJson(Map map) => _$EnvSettingsFromJson(map);

  factory EnvSettings.fromPath(String path) {
    var settings = loadEnvSettingsFromFile(path);
    return settings ?? EnvSettings(fields: {});
  }

  Map<String, dynamic> toJson() => _$EnvSettingsToJson(this);

  @override
  String toString() => '$runtimeType${toJson()}';

  static EnvSettings? loadEnvSettingsFromFile(String envSettingsPath) {
    final envSettingsFile = _loadEnvSettingsFile(envSettingsPath);
    if (envSettingsFile == null) return null;

    var envSettingsContent = envSettingsFile.readAsStringSync();
    return checkedYamlDecode(
      envSettingsContent,
      _constructEnvSettingsFromYaml,
      sourceUrl: Uri.file(envSettingsFile.path),
    );
  }

  static EnvSettings? _constructEnvSettingsFromYaml(Map? yamlMap) {
    var defineEnvMap = yamlMap?['define_env'];
    if (defineEnvMap == null) {
      return null;
    }

    return EnvSettings.fromJson(defineEnvMap);
  }

  static File? _loadEnvSettingsFile(String envSettingsPath) {
    return [envSettingsPath, 'pubspec.yaml']
        .map((e) => File(e))
        .cast()
        .firstWhere((element) => element.existsSync(), orElse: () => null);
  }
}
