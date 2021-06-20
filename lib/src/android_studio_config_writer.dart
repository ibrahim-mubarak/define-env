import 'dart:io';

import 'package:define_env/src/config_writer.dart';
import 'package:xml/xml.dart';

class AndroidStudioConfigWriter extends ConfigWriter {
  AndroidStudioConfigWriter({
    required String projectPath,
    required String dartDefineString,
    required String? configName,
  }) : super(
          projectPath: projectPath,
          dartDefineString: dartDefineString,
          configName: configName,
        );

  @override
  List<File> getMandatoryFilesToUpdate() => [];

  @override
  List<File> getOptionalFilesToUpdate() {
    var workspaceFilePath = projectPath + "/.idea/workspace.xml";
    var runDirectoryPath = projectPath + "/.run";
    var runDirectory = Directory(runDirectoryPath);
    var filesToUpdate = runDirectory
        .listSync()
        .where((element) => element.uri.toString().endsWith('.run.xml'))
        .map((element) => File(element.uri.toString()))
        .toList();

    filesToUpdate.add(File(workspaceFilePath));
    return filesToUpdate;
  }

  @override
  String writeConfig(String configXmlString) {
    var configXml = XmlDocument.parse(configXmlString);

    var flutterConfigElements = configXml
        .findAllElements('configuration')
        .where(isXmlElementFlutterConfig);

    if (configName != null) {
      flutterConfigElements =
          flutterConfigElements.where(isXmlElementSameAsConfig);
    }

    flutterConfigElements.forEach(updateAndroidStudioConfiguration);

    return configXml.toXmlString();
  }

  bool isXmlElementFlutterConfig(XmlElement element) =>
      element.getAttribute('type') == 'FlutterRunConfigurationType';

  bool isXmlElementSameAsConfig(XmlElement element) =>
      element.getAttribute('name') == configName;

  void updateAndroidStudioConfiguration(XmlElement configurationNode) {
    configurationNode
        .findAllElements('option')
        .where(elementHasArgs)
        .forEach(updateElement);
  }

  bool elementHasArgs(XmlElement element) =>
      element.getAttribute('name') == 'additionalArgs';

  void updateElement(XmlElement element) {
    var oldArguments = element.getAttribute('value')!;
    var retainedArgs = oldArguments
        .replaceAll("&quot;", "\"")
        .replaceAll(RegExp('--dart-define=[^ "]+(["\'])([^"\'])+(["\'])'), '')
        .replaceAll(RegExp('--dart-define=[^ "]+'), '')
        .replaceAll(RegExp('\s+'), ' ')
        .trim();

    element.setAttribute('value', retainedArgs + " " + dartDefineString);
  }
}
