# Usage


Copy the .env.example file to .env
```bash
cp .env.example .env
```

Then run any of the following

## Print dart-define string
Running `dart pub global run define_env` here should generate
`--dart-define=APP_TYPE=Staging --dart-define=APP_NAME="My App Staging"`

## Copy dart-define string
Running `dart pub global run define_env -c` here should generate
`--dart-define=APP_TYPE=Staging --dart-define=APP_NAME="My App Staging"`
and copy the same to clipboard

## Copy dart-define to launch.json

Running `dart pub global run define_env -l` here should generate
`--dart-define=APP_TYPE=Staging --dart-define=APP_NAME="My App Staging"`
and copy the dart defines to the args section in `launch.json` in list format

Running `dart pub global run define_env -l -n "My App"` here should generate
`--dart-define=APP_TYPE=Staging --dart-define=APP_NAME="My App Staging"`
and copy the dart defines to the args section for `"My App"` config in `launch.json` in list format

