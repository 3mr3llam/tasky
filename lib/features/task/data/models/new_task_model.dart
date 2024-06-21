import 'package:json_annotation/json_annotation.dart';
part 'new_task_model.g.dart';

@JsonSerializable()
class NewTaskModel {
  String? image;
  String? title;
  String? desc;
  String? priority;
  String? dueDate;

  NewTaskModel(
      {this.image, this.title, this.desc, this.priority, this.dueDate});

  factory NewTaskModel.fromJson(Map<String, dynamic> json) =>
      _$NewTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewTaskModelToJson(this);

  // NewTaskModel.fromJson(Map<String, dynamic> json) {
  //   image = json['image'];
  //   title = json['title'];
  //   desc = json['desc'];
  //   priority = json['priority'];
  //   dueDate = json['dueDate'];
  // }

  // Map<String, dynamic> toJson() {
  //   final data = <String, dynamic>{};
  //   data['image'] = image;
  //   data['title'] = title;
  //   data['desc'] = desc;
  //   data['priority'] = priority;
  //   data['dueDate'] = dueDate;
  //   return data;
  // }
}
