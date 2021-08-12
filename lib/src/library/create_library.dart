import 'package:code_builder/code_builder.dart';
import 'package:define_env/define_env.dart';
import 'package:define_env/src/library/field_injectors/field_injector.dart';

Library createLibrary(EnvSettings envSettings) {
  final lb = LibraryBuilder();
  final cb = ClassBuilder();

  cb
    ..name = envSettings.className
    ..constructors.add(Constructor((b) => b..name = '_'));

  // Write the fields to the library
  envSettings.fields.forEach((envFieldName, fieldSettings) {
    FieldInjector.from(fieldSettings, envFieldName).inject(lb, cb);
  });

  // Write the env class in the first place in the library
  lb.body.insert(0, cb.build());

  return lb.build();
}
