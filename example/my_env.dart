// GENERATED CODE - DO NOT MODIFY BY HAND

class MyEnv {
  MyEnv._();

  static const String appType = String.fromEnvironment('APP_TYPE');

  static const bool boolValue = bool.fromEnvironment('BOOL_VALUE');

  static const int intValue = int.fromEnvironment('INT_VALUE');

  static const MyEnum enumValue =
      MyEnum._(String.fromEnvironment('ENUM_VALUE'));

  static const int defaultValue =
      int.fromEnvironment('DEFAULT_VALUE', defaultValue: 11);
}

class MyEnum {
  const MyEnum._(this.value);

  final String value;

  static const MyEnum dev = MyEnum._('developer');

  static const MyEnum demo = MyEnum._('demo');

  static const MyEnum prod = MyEnum._('production');

  bool get isDev => this == dev;
  bool get isDemo => this == demo;
  bool get isProd => this == prod;
}
