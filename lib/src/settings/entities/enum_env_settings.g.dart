// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_env_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnumEnvSettings _$EnumEnvSettingsFromJson(Map json) => $checkedCreate(
      'EnumEnvSettings',
      json,
      ($checkedConvert) {
        final val = EnumEnvSettings(
          className: $checkedConvert('class', (v) => v as String?),
          values: $checkedConvert('values',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          names: $checkedConvert(
              'names',
              (v) =>
                  (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e as String),
                  ) ??
                  const {}),
        );
        return val;
      },
      fieldKeyMap: const {'className': 'class'},
    );

Map<String, dynamic> _$EnumEnvSettingsToJson(EnumEnvSettings instance) =>
    <String, dynamic>{
      'class': instance.className,
      'values': instance.values,
      'names': instance.names,
    };
