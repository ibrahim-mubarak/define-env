/// PascalCase to snake_case
String snakeCase(String input) {
  return input.replaceAllMapped(RegExp('[A-Z]'), (match) {
    var lower = match.group(0)!.toLowerCase();

    if (match.start > 0) {
      lower = '_$lower';
    }

    return lower;
  });
}

/// KEBAB_CASE to PascalCase
String pascalCase(String input) => _fixCase(input, true);

/// KEBAB_CASE to camelCase
String camelCase(String input) => _fixCase(input, false);

String _fixCase(String input, bool canUpperFirst) {
  final buffer = StringBuffer();
  final words = input.split('_');

  for (var i = 0; i < words.length; i++) {
    final word = words[i];

    if (i > 0 || canUpperFirst) {
      buffer.write('${word[0]}${word.substring(1).toLowerCase()}');
    } else {
      buffer.write(word.toLowerCase());
    }
  }

  return buffer.toString();
}
