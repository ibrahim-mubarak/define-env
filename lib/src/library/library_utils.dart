import 'package:code_builder/code_builder.dart';

final stringType = Reference('String');
final boolType = Reference('bool');
final intType = Reference('int');

Code valueToCode(Object value) {
  if (value is String) {
    return Code("'${value}'");
  }
  return Code('${value}');
}

extension NewEnviromentInstance on Reference {
  /// Returns a new instance of this expression with a environment constructor
  /// with default value if exist
  Expression newEnvironmentInstance(String name, [Object? defaultValue]) {
    return newInstanceNamed(
      'fromEnvironment',
      [CodeExpression(Code("'${name}'"))],
      {
        if (defaultValue != null)
          'defaultValue': CodeExpression(valueToCode(defaultValue))
      },
    );
  }
}
