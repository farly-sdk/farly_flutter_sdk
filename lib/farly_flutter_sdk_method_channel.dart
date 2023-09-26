import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'farly_flutter_sdk_platform_interface.dart';
import 'feed_element.dart';

/// An implementation of [FarlyFlutterSdkPlatform] that uses method channels.
class MethodChannelFarlyFlutterSdk extends FarlyFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('farly_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future setup({required String apiKey, required String publisherId}) async {
    await methodChannel.invokeMethod('setup', {
      'apiKey': apiKey,
      'publisherId': publisherId,
    });
  }

  @override
  Future<bool?> requestAdvertisingIdAuthorization() async {
    final result = await methodChannel
        .invokeMethod<bool>('requestAdvertisingIdAuthorization');
    return result;
  }

  @override
  Future<String?> getHostedOfferwallUrl(Map<String, dynamic> req) async {
    final result =
        await methodChannel.invokeMethod<String>('getHostedOfferwallUrl', req);
    return result;
  }

  @override
  Future<String?> showOfferwallInBrowser(Map<String, dynamic> req) async {
    final result =
        await methodChannel.invokeMethod<String>('showOfferwallInBrowser', req);
    return result;
  }

  @override
  Future<String?> showOfferwallInWebview(Map<String, dynamic> req) async {
    final result =
        await methodChannel.invokeMethod<String>('showOfferwallInWebview', req);
    return result;
  }

  @override
  Future<List<FeedElement>> getOfferwall(Map<String, dynamic> req) async {
    try {
      final result = await methodChannel.invokeMethod<List<FeedElement>>(
          'getOfferwall', req);
      return result ?? [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
