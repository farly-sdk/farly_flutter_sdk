# farly_flutter_sdk

Farly SDK for Flutter

## Installation

[![Pub Version (including pre-releases)](https://img.shields.io/pub/v/farly_flutter_sdk)](https://pub.dev/packages/farly_flutter_sdk)

This Flutter plugin is published on [pub.dev](https://pub.dev/packages/farly_flutter_sdk).

See https://pub.dev/packages/farly_flutter_sdk/install

## Usage

The full documentation is accessible at https://mobsuccess.notion.site/Farly-React-Native-SDK-82afeefd32e2423d93bf8c8e73846e14

You can also check the example app in the `example` folder.

## Working on the plugin

### Development

From vscode, open `example/main.dart` and select `Run > Start Debugging` to launch the example app. You can select the device on the bottom right corner of the screen. (you will need the flutter extension installed).

### Releasing

First, bump the version in `pubspec.yaml` and `ios/farly_flutter_sdk.yaml`.

Then run the following commands (you will need to be logged in on pub.dev):

```bash
flutter pub publish --dry-run # Check that everything is ok
flutter pub publish # Publish the new version
```

## License

MIT
