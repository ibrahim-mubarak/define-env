import 'dart:convert';
import 'dart:io';

import 'package:define_env/define_env.dart';

/// If configuration is null, update all configurations
void addToVsCode({
  required String launchJsonPath,
  String? configuration,
  required String dartDefineString,
}) {
  checkFileExists(launchJsonPath);

  var launchJsonFile = File(launchJsonPath);
  var oldLaunchConfigString = launchJsonFile
      .readAsStringSync()
      // launch.json usually contains comments, which is not valid json.
      .replaceAll(RegExp('.+//.+\n'), "");

  var launchConfig = jsonDecode(oldLaunchConfigString);

  var newConfigList = updateConfigList(
    configList: launchConfig['configurations'] as List,
    configurationName: configuration,
    dartDefineList: _splitDartDefine(dartDefineString),
  );

  launchConfig['configurations'] = newConfigList;
  var newConfigJson = _prettyJson(launchConfig);
  launchJsonFile.writeAsStringSync(newConfigJson);
}

List<dynamic> updateConfigList({
  required List<dynamic> configList,
  required String? configurationName,
  required List<String> dartDefineList,
}) {
  return configList.map((configMap) {
    if (configurationName == null || configMap['name'] == configurationName) {
      List oldArgs = configMap['args'] ?? [];
      List retainedArgs = [];
      bool previousWasDartDefine = false;
      for (int i = 0; i < oldArgs.length; i++) {
        if (oldArgs[i] == '--dart-define') {
          previousWasDartDefine = true;
          continue;
        }

        if (!previousWasDartDefine) {
          retainedArgs.add(oldArgs[i]);
        }

        previousWasDartDefine = false;
      }

      configMap['args'] = [...retainedArgs, ...dartDefineList];
    }

    return configMap;
  }).toList();
}

String joinArgs(List<dynamic>? args) {
  if (args == null) return "";

  StringBuffer buffer = StringBuffer();

  args.forEach((element) {
    buffer.write(element);

    if (element == '--dart-define') {
      buffer.write("=");
      return;
    }

    buffer.write(" ");
  });

  var argsString = buffer.toString();
  if (argsString.endsWith(" ")) {
    argsString = argsString.substring(0, argsString.length - 1);
  }

  return argsString;
}

String _prettyJson(dynamic json) {
  var spaces = ' ' * 2;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

List<String> _splitDartDefine(String? dartDefineString) {
  if (dartDefineString == null) {
    return [];
  }
  // --dart-define=MY_VAR=MY_VALUE --dart-define=MY_OTHER_VAR=MY_OTHER_VALUE --profile
  var defineEnvSeparator = " define_env ";
  return dartDefineString.split(" ").expand((element) {
    if (element.startsWith("--dart-define")) {
      return element
          .replaceAll(
            "--dart-define=",
            "--dart-define$defineEnvSeparator",
          )
          .split(defineEnvSeparator);
    }
    return [element];
  }).toList();
}
