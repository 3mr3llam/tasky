import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

// List<TodoModel> TodoModelFromJson(String str) => List<TodoModel>.from(json.decode(str).map((x) => TodoModel.fromJson(x)));

// String TodoModelToJson(List<TodoModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class TaskModel {
  @JsonKey(name: "_id")
  final String? id;
  final String? image;
  final String? title;
  final String? desc;
  final String? priority;
  final String? status;
  final String? user;
  final String? createdAt;
  final String? updatedAt;
  @JsonKey(name: "__v")
  final int? v;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  TaskModel({required this.id, required this.image, required this.title, required this.desc, required this.priority, required this.status, required this.user, required this.createdAt, required this.updatedAt, required this.v});

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
