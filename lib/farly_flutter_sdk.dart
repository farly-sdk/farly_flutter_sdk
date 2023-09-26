import 'package:farly_flutter_sdk/offerwall_request.dart';

import 'farly_flutter_sdk_platform_interface.dart';
import 'feed_element.dart';

class FarlyFlutterSdk {
  Future<String?> getPlatformVersion() {
    return FarlyFlutterSdkPlatform.instance.getPlatformVersion();
  }

  Future setup({required String apiKey, required String publisherId}) {
    return FarlyFlutterSdkPlatform.instance
        .setup(apiKey: apiKey, publisherId: publisherId);
  }

  /// Request authorization to use the advertising identifier.
  ///
  /// This method is only available on iOS
  Future<bool?> requestAdvertisingIdAuthorization() {
    return FarlyFlutterSdkPlatform.instance.requestAdvertisingIdAuthorization();
  }

  Map<String, dynamic> transformRequest(OfferWallRequest req) {
    final userSignupDate = req.userSignupDate;
    return {
      ...req.toJson(),
      'userSignupDate': userSignupDate?.millisecondsSinceEpoch,
    };
  }

  Future<String?> getHostedOfferwallUrl(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .getHostedOfferwallUrl(transformRequest(req));
  }

  Future<String?> showOfferwallInBrowser(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .showOfferwallInBrowser(transformRequest(req));
  }

  Future<String?> showOfferwallInWebview(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .showOfferwallInWebview(transformRequest(req));
  }

  Future<List<FeedElement>> getOfferwall(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance.getOfferwall(transformRequest(req));
  }
}
