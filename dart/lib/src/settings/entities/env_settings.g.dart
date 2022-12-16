// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvSettings _$EnvSettingsFromJson(Map json) => $checkedCreate(
      'EnvSettings',
      json,
      ($checkedConvert) {
        final val = EnvSettings(
          fileWidth: $checkedConvert('file_width', (v) => v as int? ?? 80),
          filePath: $checkedConvert('file_path', (v) => v as String? ?? 'lib'),
          className: $checkedConvert('class', (v) => v as String? ?? 'Env'),
          fields: $checkedConvert(
              'fields',
              (v) => (v as Map).map(
                    (k, e) => MapEntry(
                        k as String, FieldEnvSettings.fromJson(e as Map)),
                  )),
        );
        return val;
      },
      fieldKeyMap: const {
        'fileWidth': 'file_width',
        'filePath': 'file_path',
        'className': 'class'
      },
    );

Map<String, dynamic> _$EnvSettingsToJson(EnvSettings instance) =>
    <String, dynamic>{
      'file_width': instance.fileWidth,
      'file_path': instance.filePath,
      'class': instance.className,
      'fields': instance.fields,
    };
