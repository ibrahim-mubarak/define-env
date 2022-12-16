import 'dart:io';

import 'package:console/console.dart';

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
