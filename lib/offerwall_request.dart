enum UserGender {
  male,
  female,
  other,
}

class OfferWallRequest {
  /// Your unique id for the current user - the only required parameter
  final String userId;

  /// Current zipCode of the user, should be fetched from geolocation, not from geoip
  final String? zipCode;

  /// Current 2 letters country code of the user,
  /// if not provided will default to the user's preferred region
  final String? countryCode;

  /// Your user's age
  final int? userAge;

  /// Gender of the user, to access targetted campaigns
  final UserGender? userGender;

  /// Date at which your user did signup
  final DateTime? userSignupDate;

  /// parameters you wish to get back in your callback
  final List<String>? callbackParameters;

  OfferWallRequest({
    required this.userId,
    this.zipCode,
    this.countryCode,
    this.userAge,
    this.userGender,
    this.userSignupDate,
    this.callbackParameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'zipCode': zipCode,
      'countryCode': countryCode,
      'userAge': userAge,
      'userGender': userGender?.toString().split('.').last,
      'userSignupDate': userSignupDate?.millisecondsSinceEpoch,
      'callbackParameters': callbackParameters,
    };
  }
}
