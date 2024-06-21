// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewTaskModel _$NewTaskModelFromJson(Map<String, dynamic> json) => NewTaskModel(
      image: json['image'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      priority: json['priority'] as String?,
      dueDate: json['dueDate'] as String?,
    );

Map<String, dynamic> _$NewTaskModelToJson(NewTaskModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'title': instance.title,
      'desc': instance.desc,
      'priority': instance.priority,
      'dueDate': instance.dueDate,
    };
