# farly_flutter_sdk

Farly SDK for Flutter

## Installation

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/farly_flutter_sdk)](https://pub.dev/packages/farly_flutter_sdk)

This Flutter plugin is published on [pub.dev](https://pub.dev/packages/farly_flutter_sdk).

See https://pub.dev/packages/farly_flutter_sdk/install

## Usage

The full documentation is accessible at https://mobsuccess-group.notion.site/Farly-Flutter-SDK-2e2d6183107581378176f97d897d9497

You can also check the example app in the `example` folder.

## Working on the plugin

### Development

From vscode, open `example/main.dart` and select `Run > Start Debugging` to launch the example app. You can select the device on the bottom right corner of the screen. (you will need the flutter extension installed).

### Releasing

First, bump the version in `pubspec.yaml` and `ios/farly_flutter_sdk.podspec`.
Don't forget to fill in the CHANGELOG.md file.

Then run the following commands (you will need to be logged in on pub.dev):

```bash
flutter pub publish --dry-run # Check that everything is ok
flutter pub publish # Publish the new version
```

## License

MIT
