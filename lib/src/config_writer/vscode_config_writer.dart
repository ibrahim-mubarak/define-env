import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/config_writer/config_writer.dart';

/// [ConfigWriter] for VS Code.
///
/// This [ConfigWriter] takes the launch.json file, reads it and retains non dart-define arguments.
/// The new dart-define string generated from the .env file is appended to the retained arguments.
class VscodeConfigWriter extends ConfigWriter {
  /// [projectPath] is the path to VS Code project. It should contain the '.vscode/launch.json' file.
  /// [dartDefineString] is the dart-define string which is to be written to the config
  /// [configName] is the name of an existing configuration in launch.json. A config is not created if it is not found.
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
    try {
      Map<String, dynamic> configJson = jsonDecode(fileContent);
      var configs = (configJson['configurations'] as List);

      List<String> dartDefineList = getDartDefineList();

      if (configName != null) {
        var namedConfig = configs
            .where((config) => config['name'] == configName)
            .toList()
            .first;
        var updatedNamedConfig = updateConfig(namedConfig, dartDefineList);
        configs.removeWhere((element) => element['name'] == configName);
        configs.add(updatedNamedConfig);
        configJson['configurations'] = configs;
      } else {
        configJson['configurations'] = configs
            .map((configMap) => updateConfig(configMap, dartDefineList))
            .toList();
      }
      return prettifyJson(configJson);
    } catch (err) {
      print(
          'Exception occurred: Possible error is comments in JSON. Additional information: $err');
      return fileContent;
    }
  }

  /// Update a single VS Code [config] with [dartDefineList].
  Map<String, dynamic> updateConfig(
    Map<String, dynamic> config,
    List<String> dartDefineList,
  ) {
    Map<String, dynamic> configUpdate = Map<String, dynamic>.from(config);

    print('ConfigUpdate: $configUpdate');
    if (configUpdate.containsKey('args')) {
      configUpdate.remove('args');
    }
    configUpdate.putIfAbsent('args', () => dartDefineList);

    print('ConfigUpdated: $configUpdate');
    return configUpdate;
  }

  /// Pretty Print [json]
  String prettifyJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }

  /// Take [argList] and return only non dart define arguments from the list
  ///
  /// This is useful when you have arguments such as --profile or --release.
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

  /// Splits the dart-define string into a list format as required by VS Code.
  List<String> getDartDefineList() {
    return (dartDefineString.split("--dart-define=")..removeAt(0))
        .expand((element) => ["--dart-define", element.trim()])
        .toList();
  }
}
