import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:define_env/src/settings/entities/env_settings.dart';
import 'package:recase/recase.dart';

/// Write the [library] locally according to the defined [settings]
void writeLibrary(EnvSettings settings, Library library) {
  final directoryPath = settings.filePath;

  final emitter = DartEmitter.scoped(useNullSafetySyntax: true);

  final formatter = DartFormatter(
    pageWidth: settings.fileWidth,
  );

  final code = formatter.format('${library.accept(emitter)}');

  final fileName = settings.className.snakeCase;

  final filePath = '$directoryPath/$fileName.dart';

  final fileContent = '// GENERATED CODE - DO NOT MODIFY BY HAND\n\n$code';

  // Create output directory
  final directory = Directory(directoryPath);
  if (!directory.existsSync()) directory.createSync(recursive: true);

  // Create and write output file
  File(filePath).writeAsStringSync(fileContent);
}
