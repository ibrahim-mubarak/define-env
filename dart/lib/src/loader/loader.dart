import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:define_env/src/utils.dart';
import 'package:dotenv/dotenv.dart';
import 'package:dotenv/src/parser.dart';

abstract class Loader {
  Future<DotEnv> load();
}

class FileLoader extends Loader {
  final String file;

  FileLoader(this.file);

  @override
  Future<DotEnv> load() async {
    checkFileExists(file);

    return DotEnv()..load([file]);
  }
}

class StdinLoader extends Loader {
  static const parser = Parser();

  StdinLoader();

  DotEnv dotEnv = DotEnv();

  @override
  Future<DotEnv> load() {
    var completer = Completer<DotEnv>();
    List<String> finalData = [];
    stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((data) => finalData.add(data))
      ..onDone(() {
        dotEnv.addAll(parser.parse(finalData));
        completer.complete(dotEnv);
      });

    return completer.future;
  }
}
