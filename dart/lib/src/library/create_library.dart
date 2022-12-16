import 'package:code_builder/code_builder.dart';
import 'package:define_env/define_env.dart';
import 'package:define_env/src/library/field_injectors/field_injector.dart';

Library createLibrary(EnvSettings envSettings) {
  final libraryBuilder = LibraryBuilder();
  final classBuilder = ClassBuilder();

  classBuilder
    ..name = envSettings.className
    ..constructors.add(Constructor((b) => b..name = '_'));

  // Write the fields to the library
  envSettings.fields.forEach((envFieldName, fieldSettings) {
    FieldInjector.from(fieldSettings, envFieldName)
        .inject(libraryBuilder, classBuilder);
  });

  // Write the env class in the first place in the library
  libraryBuilder.body.insert(0, classBuilder.build());

  return libraryBuilder.build();
}
