
import 'package:json_annotation/json_annotation.dart';
part 'refresh_access_token_response_model.g.dart';

@JsonSerializable()
class RefreshAccessTokenResponseModel {
  @JsonKey(name: "access_token")
  final String? accessToken;

  RefreshAccessTokenResponseModel(this.accessToken);

  factory RefreshAccessTokenResponseModel.fromJson(Map<String, dynamic> json) => _$RefreshAccessTokenResponseModelFromJson(json);
  //
  Map<String, dynamic> toJson() => _$RefreshAccessTokenResponseModelToJson(this);
}