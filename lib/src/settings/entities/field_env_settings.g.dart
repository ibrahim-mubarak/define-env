// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_env_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldEnvSettings _$FieldEnvSettingsFromJson(Map json) => $checkedCreate(
      'FieldEnvSettings',
      json,
      ($checkedConvert) {
        final val = FieldEnvSettings(
          type: $checkedConvert(
              'type', (v) => _$enumDecode(_$FieldTypeEnvSettingsEnumMap, v)),
          enumSettings: $checkedConvert('enum',
              (v) => v == null ? null : EnumEnvSettings.fromJson(v as Map)),
          defaultValue: $checkedConvert('default', (v) => v),
          fieldName: $checkedConvert('field_name', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'enumSettings': 'enum',
        'defaultValue': 'default',
        'fieldName': 'field_name'
      },
    );

Map<String, dynamic> _$FieldEnvSettingsToJson(FieldEnvSettings instance) =>
    <String, dynamic>{
      'type': _$FieldTypeEnvSettingsEnumMap[instance.type],
      'enum': instance.enumSettings,
      'default': instance.defaultValue,
      'field_name': instance.fieldName,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$FieldTypeEnvSettingsEnumMap = {
  FieldTypeEnvSettings.string: 'String',
  FieldTypeEnvSettings.bool: 'bool',
  FieldTypeEnvSettings.int: 'int',
  FieldTypeEnvSettings.enum$: 'enum',
};
