import 'package:hive/hive.dart';
import 'package:tasky/features/task/data/models/task_model.dart';

@HiveType(typeId: 4)
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 4;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
        id: reader.readString(),
        image: reader.readString(),
        title: reader.readString(),
        desc: reader.readString(),
        priority: reader.readString(),
        status: reader.readString(),
        user: reader.readString(),
        createdAt: reader.readString(),
        updatedAt: reader.readString(),
        v: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id ?? "");
    writer.writeString(obj.image ?? "");
    writer.writeString(obj.title ?? "");
    writer.writeString(obj.desc ?? "");
    writer.writeString(obj.priority ?? "");
    writer.writeString(obj.status ?? "");
    writer.writeString(obj.user ?? "");
    writer.writeString(obj.createdAt ?? "");
    writer.writeString(obj.updatedAt ?? "");
    writer.writeInt(obj.v ?? 0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TaskModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
