import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farly_flutter_sdk/farly_flutter_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFarlyFlutterSdk platform = MethodChannelFarlyFlutterSdk();
  const MethodChannel channel = MethodChannel('farly_flutter_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
}
