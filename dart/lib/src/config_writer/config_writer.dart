import 'dart:io';

import 'package:define_env/src/utils.dart';

abstract class ConfigWriter {
  final String projectPath;
  final String dartDefineString;
  final String? configName;

  ConfigWriter({
    required this.projectPath,
    required this.dartDefineString,
    required this.configName,
  });

  List<File> getOptionalFilesToUpdate();

  List<File> getMandatoryFilesToUpdate();

  String writeConfig(String fileContent);

  void call() {
    var mandatoryFiles = getMandatoryFilesToUpdate();
    mandatoryFiles.forEach((file) => checkFileExists(file.path));

    <File>[]
      ..addAll(mandatoryFiles)
      ..addAll(getOptionalFilesToUpdate())
      ..forEach((file) {
        file.writeAsStringSync(writeConfig(file.readAsStringSync()));
      });
  }
}
