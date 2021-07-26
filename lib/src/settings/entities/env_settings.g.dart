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
          fields: $checkedConvert(
              'fields',
              (v) => (v as Map).map(
                    (k, e) => MapEntry(
                        k as String, FieldEnvSettings.fromJson(e as Map)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$EnvSettingsToJson(EnvSettings instance) =>
    <String, dynamic>{
      'fields': instance.fields,
    };
