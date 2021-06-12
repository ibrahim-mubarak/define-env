import 'dart:io';

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
  ..addOption(
    'config-name',
    abbr: 'n',
    help: 'Configuration name in vscode launch.json',
  );

void main(List<String> argv) {
  Console.init();

  var opts = _argPsr.parse(argv);

  if (opts['help'] == true) return _usage();

  loadEnvFromFile(opts['file'] as String);

  var dartDefineString = convertEnvMapToDartDefineString(dotEnv.env);

  if (opts['print']) {
    print(dartDefineString);
  }

  if (opts['copy']) {
    copyToClipboard(dartDefineString);
  }

  if (opts['vscode']) {
    addToVsCode(
      launchJsonPath: '.vscode/launch.json',
      configuration: opts['config-name'],
      dartDefineString: dartDefineString,
    );
  }
}

void copyToClipboard(String content) {
  if (Platform.isMacOS) {
    doPbCopy(content).then((value) {
      Console.setBackgroundColor(Color.GREEN.id);
      Console.setTextColor(Color.BLACK.id);
      Console.write('\tCopied to clipboard\t\n');
    });
    return;
  }

  copyToClipboardLinux(content);
}

void _usage() =>
    print('\nUsage: pub global run define_env \n\n${_argPsr.usage}\n');

String convertEnvMapToDartDefineString(Map<String, String> msg) {
  StringBuffer buffer = StringBuffer();
  msg.forEach((key, value) {
    buffer.write("--dart-define=$key=$value ");
  });
  var string = buffer.toString();
  var finalStringToPrintAndCopy = string.substring(0, string.length - 1);
  return finalStringToPrintAndCopy;
}

Future doPbCopy(String content) {
  return Process.start('/usr/bin/pbcopy', []).then((process) {
    process.stdin.write(content);
    process.stdin.close();
  });
}

void copyToClipboardLinux(String content) {
  var clipboard = getClipboard();
  if (clipboard == null) {
    Console.write("Could not copy to clipboard");
    return;
  }

  clipboard.setContent(content);
}
