import 'package:hive/hive.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';

@HiveType(typeId: 0)
class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 0;

  @override
  ProfileModel read(BinaryReader reader) {
    return ProfileModel(
      sId: reader.readString(),
      displayName: reader.readString(),
      username: reader.readString(),
      roles: reader.readList().cast<String>(),
      active: reader.readBool(),
      experienceYears: reader.readInt(),
      address: reader.readString(),
      level: reader.readString(),
      createdAt: reader.readString(),
      updatedAt: reader.readString(),
      iV: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer.writeString(obj.sId ?? "");
    writer.writeString(obj.displayName ?? "");
    writer.writeString(obj.username?? "");
    writer.writeList(obj.roles!);
    writer.writeBool(obj.active?? true);
    writer.writeInt(obj.experienceYears ?? 0);
    writer.writeString(obj.address ?? "");
    writer.writeString(obj.level ?? "");
    writer.writeString(obj.createdAt ?? "");
    writer.writeString(obj.updatedAt ?? "");
    writer.writeInt(obj.iV ?? 0);
  }
}
