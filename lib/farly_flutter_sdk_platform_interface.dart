import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'farly_flutter_sdk_method_channel.dart';
import 'feed_element.dart';

abstract class FarlyFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a FarlyFlutterSdkPlatform.
  FarlyFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FarlyFlutterSdkPlatform _instance = MethodChannelFarlyFlutterSdk();

  /// The default instance of [FarlyFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFarlyFlutterSdk].
  static FarlyFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FarlyFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(FarlyFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future setup({required String apiKey, required String publisherId}) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<bool?> requestAdvertisingIdAuthorization() {
    throw UnimplementedError(
        'requestAdvertisingIdAuthorization() has not been implemented.');
  }

  Future<String?> getHostedOfferwallUrl(Map<String, dynamic> req) {
    throw UnimplementedError(
        'getHostedOfferwallUrl() has not been implemented.');
  }

  Future<String?> showOfferwallInBrowser(Map<String, dynamic> req) {
    throw UnimplementedError(
        'showOfferwallInBrowser() has not been implemented.');
  }

  Future<String?> showOfferwallInWebview(Map<String, dynamic> req) {
    throw UnimplementedError(
        'showOfferwallInWebview() has not been implemented.');
  }

  Future<List<FeedElement>> getOfferwall(Map<String, dynamic> req) {
    throw UnimplementedError('getOfferwall() has not been implemented.');
  }
}
