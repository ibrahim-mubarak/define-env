import 'dart:io';

import 'package:define_env/src/config_writer.dart';
import 'package:xml/xml.dart';

/// [ConfigWriter] for Android Studio and Intellij IDEs.
///
/// This [ConfigWriter] reads all xml files containing Run configuration and retains non dart-define arguments.
/// The new dart-define string generated from the .env file is appended to the retained arguments.
class AndroidStudioConfigWriter extends ConfigWriter {
  /// [projectPath] is the path to Android Studio project.
  /// It should contain the '.idea/workspace.xml' file or '.run/*.xml' files
  /// [dartDefineString] is the dart-define string which is to be written to the config
  /// [configName] is the name of an existing configuration in launch.json. A config is not created if it is not found.
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

  void updateAndroidStudioConfiguration(XmlElement configurationNode) =>
      configurationNode
          .findAllElements('option')
          .where(elementHasArgs)
          .forEach(updateElement);

  /// Checks if [element] has 'additionalArgs'. We should ideally check for 'attachArgs' too I suppose.
  bool elementHasArgs(XmlElement element) =>
      element.getAttribute('name') == 'additionalArgs';

  /// Update the Configuration [option] with new dart-define while preserving old arguments.
  void updateElement(XmlElement option) {
    var oldArguments = option.getAttribute('value')!;
    var retainedArgs = getRetainedArgs(oldArguments);

    option.setAttribute(
      'value',

      /// We are trimming here because retained arguments can be empty
      /// and because of that our dart-defines will not be parsed properly
      /// because of the extra spaces
      (retainedArgs + " " + dartDefineString).trim(),
    );
  }

  /// Remove all dart-defines from [oldArguments] and return whatever is remaining.
  String getRetainedArgs(String oldArguments) {
    var retainedArgs = oldArguments
        .replaceAll("&quot;", "\"")
        .replaceAll(RegExp('--dart-define=[^ "]+(["\'])([^"\'])+(["\'])'), '')
        .replaceAll(RegExp('--dart-define=[^ "]+'), '')
        .replaceAll(RegExp('\s+'), ' ')
        .trim();
    return retainedArgs;
  }
}
