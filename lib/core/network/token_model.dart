// models/response_model.dart

class TokenModel {
  final String? refreshToken;
  final String? accessToken;
  final int? errorCode;

  TokenModel(this.refreshToken, this.accessToken, this.errorCode);

  // Factory constructor to create a TokenModel from JSON
  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      json['refresh_token'],
      json['access_token'],
      json['errorCode'],
    );
  }

  // Method to convert a TokenModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
      'access_token': accessToken,
      'errorCode': errorCode,
    };
  }
}
