define_env
======

Load variables from a `.env` file into a dart-define string and copy it to your IDE Config or to the
clipboard.

[![Pub Version][pub-badge]][pub]
[![Documentation][dartdocs-badge]][dartdocs]

[pub-badge]: https://img.shields.io/pub/v/define_env.svg

[pub]: https://pub.dartlang.org/packages/define_env

[dartdocs-badge]: https://img.shields.io/badge/dartdocs-reference-blue.svg

[dartdocs]: https://www.dartdocs.org/documentation/define_env/latest

## Usage

Get the latest version from pub:

```sh
$ dart pub global activate define_env
```

You can add the Pub Cache directory to execute the command easily. 
[Learn More](https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path)

### Print

```sh
$ define_env      # generate dart define string and print it to stdout
```

You can skip printing using the `--no-print` flag

### Copy to clipboard

```sh
$ define_env -c      # generate dart define string and copy to clipboard 
```

### Copy to IDE

**Note**

- When copying to IDE config, `define_env` tries to preserve existing arguments and overwrites only
  the dart-define statements. This is not thoroughly tested and if you face problems with additional
  arguments please create an issue.

#### VS Code launch.json

```sh
$ define_env -l      # generate dart define string and copy it to launch.json
```

By default, all configurations in `launch.json` are updated. If you want to update only a specific
configuration, you can do the following

```sh
$ define_env -l -n staging     # generate dart define string and copy it to "staging" configuration in launch.json
```

**Note**

- `launch.json` may sometimes contain comments. These comments cannot be preserved as of now. If
  this is important then you should avoid this package

#### Android Studio

```sh
$ define_env -a      # generate dart define string and copy it to all run configs
```

By default, all configurations in `.idea/workspace.xml` and `.run/` are updated. If you want to
update only a specific configuration, you can do the following

```sh
$ define_env -a -n staging     # generate dart define string and copy it to "staging" configuration only
```

### Env Validation

You can add validation for your env by defining a `define_env.yaml` or adding a `define_env`section
to your `pubspec.yaml`

```yaml
define_env:
  file_path: example
  class: MyEnv
  fields:
    <FIELD_NAME>:
      type: enum     # String | bool | int | enum
      default:       # If it is set the field in the env is optional.
      enum: # Defines the possible values of the enum. Required field when the type is enum.
        values:
          - value1
          - value2
```

### Env Class Generation

Running `define_env` will automatically generate an Env Class for you to use in your project. The
class name is defined by `class` and File Path is defined by `file_path` in `define_env` section of
your `define_env.yaml` or `pubspec.yaml`. If you don't want a class to be generated, you can pass
the `--no-generate` flag.

```sh
$ define_env --no-generate     # Skip Env Class generation
```

## Discussion

Use the [issue tracker][tracker] for bug reports and feature requests.

[tracker]: https://github.com/ibrahim-mubarak/define_env/issues

## Roadmap

- [x] Add support for Android Studio and Intellij.
- [x] Add validation support to see warn if any environment variable is missing.
- [x] Generate `Config` class from `.env` files which extract values from environment.
- [ ] Make Android Studio and VS Code extensions and plugins to update config automatically
  when `.env` files are updated.
- [ ] Copy config name directly from `.env` files. ex `.env.staging` is copied to staging config.
- [ ] Simplify command usage. ex `define_env:print` `define_env:copy` `define_env:vscode` etc.
- [ ] Add Stdin support.
- [ ] Add support for config files created with `melos`