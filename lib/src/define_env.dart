import 'dart:io';

import 'package:console/console.dart';
import 'package:dotenv/dotenv.dart' as dotEnv;

void loadEnvFromFile(String file) {
  checkFileExists(file);
  dotEnv.load(file);
  Platform.environment.forEach((key, value) => dotEnv.env.remove(key));
}

void checkFileExists(String file) {
  if (!File(file).existsSync()) {
    Console.setTextColor(Color.RED.id);
    Console.write("$file not found\n");
    exit(-1);
  }
}

void checkDirectoryExists(String file) {
  if (!Directory(file).existsSync()) {
    Console.setTextColor(Color.RED.id);
    Console.write("$file not found\n");
    exit(-1);
  }
}
