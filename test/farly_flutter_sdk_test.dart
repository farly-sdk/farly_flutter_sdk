import 'package:flutter_test/flutter_test.dart';
import 'package:farly_flutter_sdk/farly_flutter_sdk.dart';
import 'package:farly_flutter_sdk/farly_flutter_sdk_platform_interface.dart';
import 'package:farly_flutter_sdk/farly_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFarlyFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements FarlyFlutterSdkPlatform {}

void main() {
  final FarlyFlutterSdkPlatform initialPlatform =
      FarlyFlutterSdkPlatform.instance;

  test('$MethodChannelFarlyFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFarlyFlutterSdk>());
  });
}
