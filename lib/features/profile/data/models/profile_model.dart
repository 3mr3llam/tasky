import 'package:json_annotation/json_annotation.dart';
part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  @JsonKey(name: "_id")
  final String? sId;
  final String? displayName;
  final String? username;
  final List<String>? roles;
  final bool? active;
  final int? experienceYears;
  final String? address;
  final String? level;
  final String? createdAt;
  final String? updatedAt;
  @JsonKey(name: "__v")
  final int? iV;

  ProfileModel(
      {required this.sId,
      required this.displayName,
      required this.username,
      required this.roles,
      required this.active,
      required this.experienceYears,
      required this.address,
      required this.level,
      required this.createdAt,
      required this.updatedAt,
      required this.iV});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  // Choose one of person field to be the key
  // this key will be used to save to local database

  String? get key => sId;
}
