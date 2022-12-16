import 'package:json_annotation/json_annotation.dart';

enum FieldTypeEnvSettings {
  @JsonValue('String')
  string,
  bool,
  int,
  @JsonValue('enum')
  enum$,
}
