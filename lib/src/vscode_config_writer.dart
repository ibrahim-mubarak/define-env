import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/config_writer.dart';

class VscodeConfigWriter extends ConfigWriter {
  VscodeConfigWriter({
    required String projectPath,
    required String dartDefineString,
    required String? configName,
  }) : super(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
        );

  @override
  List<File> getMandatoryFilesToUpdate() => [
        File(projectPath + "/.vscode/launch.json"),
      ];

  @override
  List<File> getOptionalFilesToUpdate() => [];

  @override
  String writeConfig(String fileContent) {
    /// launch.json usually contains comments, which is valid only in JSON5.
    /// At this point however we cannot preserve these comments.
    fileContent = fileContent.replaceAll(RegExp('.+//.+\n'), "");

    var configJson = jsonDecode(fileContent);

    var configList = (configJson['configurations'] as Iterable);

    if (configName != null) {
      configList = configList.where((config) => config['name'] == configName);
    }

    var dartDefineList = splitDartDefine(dartDefineString);

    configJson['configurations'] =
        configList.map((configMap) => updateConfig(configMap, dartDefineList));

    return prettifyJson(configJson);
  }

  Map<String, dynamic> updateConfig(
    Map<String, dynamic> configMap,
    List<String> newDartDefineList,
  ) {
    return configMap.update(
      'args',
      (value) => getNonDartDefineArguments(value).followedBy(newDartDefineList),
      ifAbsent: () => newDartDefineList,
    );
  }

  String prettifyJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  /// Take [argList] and return only non dart define arguments from the list
  List<dynamic> getNonDartDefineArguments(List<dynamic> argList) {
    bool previousWasDartDefine = false;

    List retainedArgs = [];
    argList.forEach((arg) {
      if (arg == '--dart-define') {
        previousWasDartDefine = true;
        return;
      }

      if (!previousWasDartDefine) {
        retainedArgs.add(arg);
      }

      previousWasDartDefine = false;
    });
    return retainedArgs;
  }

  List<String> splitDartDefine(String? dartDefineString) {
    if (dartDefineString == null) {
      return [];
    }

    return (dartDefineString.split("--dart-define=")..removeAt(0))
        .expand((element) {
      return ["--dart-define", element.trim()];
    }).toList();
  }
}
