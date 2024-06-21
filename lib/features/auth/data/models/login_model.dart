import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginModel {
  @JsonKey(name: "_id")
  final String id;

  final String? displayName;

  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  LoginModel(this.displayName, {required this.id, required this.accessToken, required this.refreshToken});

  /// Connect the generated [_$LoginModelFromJson] function to the `fromJson`
  /// factory.
  factory LoginModel.fromJson(Map<String, dynamic> json) => _$LoginModelFromJson(json);

  /// Connect the generated [_$LoginModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LoginModelToJson(this);
}
