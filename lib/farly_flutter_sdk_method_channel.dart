import 'dart:convert';

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
  Future setup({required String publisherId}) async {
    await methodChannel.invokeMethod('setup', {
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
      var result =
          await methodChannel.invokeMethod<String?>('getOfferwall', req);
      if (result == null) {
        return [];
      }
      final feedElementsJson = jsonDecode(result) as List<dynamic>;
      return feedElementsJson
          .map((e) => FeedElement.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
