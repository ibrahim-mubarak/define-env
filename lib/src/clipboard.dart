import 'dart:io';

import 'package:console/console.dart';

Future<void> copyToClipboard(String content) async {
  if (Platform.isMacOS) {
    return copyToClipboardMac(content);
  }

  return copyToClipboardLinux(content);
}

Future copyToClipboardMac(String content) {
  return Process.start('/usr/bin/pbcopy', []).then((process) {
    process.stdin.write(content);
    process.stdin.close();
  });
}

Future<void> copyToClipboardLinux(String content) async {
  var clipboard = getClipboard();
  if (clipboard == null) {
    throw Exception('Could not fetch clipboard');
  }

  clipboard.setContent(content);
}
