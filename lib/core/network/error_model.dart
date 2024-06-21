import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  String? message;
  String? error;
  int? statusCode;

  ErrorModel(this.message, this.error, this.statusCode);

  factory ErrorModel.fromJson(Map<String, dynamic> json) => _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
