import 'dart:io';

import 'package:checked_yaml/checked_yaml.dart';
import 'package:define_env/src/settings/entities/field_env_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'env_settings.g.dart';

@JsonSerializable(anyMap: true, fieldRename: FieldRename.snake, checked: true)
class EnvSettings {
  /// The width of the file. Set this field when using a different file format
  final int fileWidth;

  /// The target directory of the file containing the env dart class
  final String filePath;

  /// The name of the env's dart class
  @JsonKey(name: 'class')
  final String className;

  /// Map with the key the name of the field in the env and
  /// with the value the settings of that field
  ///
  /// It must contain at least one field in order to validate the .env file and
  /// to generate the corresponding dart class
  final Map<String, FieldEnvSettings> fields;

  EnvSettings({
    this.fileWidth = 80,
    this.filePath = 'lib',
    this.className = 'Env',
    required this.fields,
  });

  factory EnvSettings.fromJson(Map map) => _$EnvSettingsFromJson(map);

  factory EnvSettings.fromPath(String path) {
    var settings = loadEnvSettingsFromFile(path);
    return settings ?? EnvSettings(fields: const {});
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
