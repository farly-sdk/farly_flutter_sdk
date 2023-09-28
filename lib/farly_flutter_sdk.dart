import 'package:farly_flutter_sdk/offerwall_request.dart';

import 'farly_flutter_sdk_platform_interface.dart';
import 'feed_element.dart';

class FarlyFlutterSdk {
  /// Initializes the Farly SDK with the given [apiKey] and [publisherId].
  /// This method must be called before any other method.
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

  Map<String, dynamic> _transformRequest(OfferWallRequest req) {
    final userSignupDate = req.userSignupDate;
    return {
      ...req.toJson(),
      'userSignupDate': userSignupDate?.millisecondsSinceEpoch,
    };
  }

  /// Returns the URL of the hosted offerwall for the given [req].
  Future<String?> getHostedOfferwallUrl(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .getHostedOfferwallUrl(_transformRequest(req));
  }

  /// Open the offerwall for the given [req] in the browser.
  Future<String?> showOfferwallInBrowser(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .showOfferwallInBrowser(_transformRequest(req));
  }

  /// Open the offerwall for the given [req] in a webview.
  Future<String?> showOfferwallInWebview(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .showOfferwallInWebview(_transformRequest(req));
  }

  /// Returns the list of feed elements for the given [req]. It is your responsibility to display them.
  Future<List<FeedElement>> getOfferwall(OfferWallRequest req) {
    return FarlyFlutterSdkPlatform.instance
        .getOfferwall(_transformRequest(req));
  }
}
