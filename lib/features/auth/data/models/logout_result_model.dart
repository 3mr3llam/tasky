import 'package:json_annotation/json_annotation.dart';
part 'logout_result_model.g.dart';

@JsonSerializable()
class LogoutResultModel {
  final String? success;

  factory LogoutResultModel.fromJson(Map<String, dynamic> json) => _$LogoutResultModelFromJson(json);

  LogoutResultModel(this.success);

  /// Connect the generated [_$LogoutResultModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LogoutResultModelToJson(this);
}