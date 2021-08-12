import 'package:args/args.dart';
import 'package:console/console.dart';
import 'package:define_env/define_env.dart';
import 'package:dotenv/dotenv.dart' as dotEnv;

final _argPsr = new ArgParser()
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this help text.')
  ..addOption(
    'file',
    abbr: 'f',
    defaultsTo: '.env',
    help:
        'File to read.\nProvides environment variable definitions, one per line.',
  )
  ..addFlag(
    'print',
    abbr: 'p',
    defaultsTo: true,
    help: "Print dart define to stdout",
  )
  ..addFlag(
    'copy',
    abbr: 'c',
    help: 'Copy to clipboard',
    negatable: false,
  )
  ..addFlag(
    'vscode',
    abbr: 'l',
    help: 'Add to VS Code launch.json',
    negatable: false,
  )
  ..addFlag(
    'android-studio',
    abbr: 'a',
    help: 'Add to Android Studio run config',
    negatable: false,
  )
  ..addOption(
    'config-name',
    abbr: 'n',
    help: 'Configuration name to use in IDE',
  )
  ..addOption(
    'settings',
    abbr: 's',
    defaultsTo: 'define_env.yaml',
    help: 'The yaml file settings to validate the .env file.',
  );

void main(List<String> argv) {
  Console.init();

  var opts = _argPsr.parse(argv);

  if (opts['help'] == true) return _usage();

  loadEnvFromFile(opts['file'] as String);

  final envSettings = loadEnvSettings(opts['settings'] as String);
  isEnvValid(dotEnv.env, envSettings);

  // If the path to the env library is defined it creates and writes the library
  if (envSettings.fields.isNotEmpty) {
    final library = createLibrary(envSettings);
    writeLibrary(envSettings, library);
  }

  var dartDefineString = convertEnvMapToDartDefineString(dotEnv.env);

  if (opts['print']) {
    print(dartDefineString);
  }

  if (opts['copy']) {
    copyToPlatformClipboard(dartDefineString);
  }

  if (opts['vscode']) {
    VscodeConfigWriter(
      dartDefineString: dartDefineString,
      configName: opts['config-name'],
      projectPath: '.',
    ).call();
  }

  if (opts['android-studio']) {
    AndroidStudioConfigWriter(
      dartDefineString: dartDefineString,
      configName: opts['config-name'],
      projectPath: '.',
    ).call();
  }
}

void copyToPlatformClipboard(String dartDefineString) {
  copyToClipboard(dartDefineString).then((value) {
    Console.setBackgroundColor(Color.GREEN.id);
    Console.setTextColor(Color.BLACK.id);
    Console.write('\tCopied to clipboard\t\n');
  }).onError((error, stackTrace) {
    Console.setBackgroundColor(Color.RED.id);
    Console.setTextColor(Color.WHITE.id);
    Console.write('\tCould not copied to clipboard: $error\t\n');
  });
}

void _usage() =>
    print('\nUsage: pub global run define_env \n\n${_argPsr.usage}\n');
