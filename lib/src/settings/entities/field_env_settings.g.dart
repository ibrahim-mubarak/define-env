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
          enumValues: $checkedConvert('enum_values',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          defaultValue: $checkedConvert('default', (v) => v),
        );
        return val;
      },
      fieldKeyMap: const {
        'enumValues': 'enum_values',
        'defaultValue': 'default'
      },
    );

Map<String, dynamic> _$FieldEnvSettingsToJson(FieldEnvSettings instance) =>
    <String, dynamic>{
      'type': _$FieldTypeEnvSettingsEnumMap[instance.type],
      'enum_values': instance.enumValues,
      'default': instance.defaultValue,
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
