import 'package:hive/hive.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';

class HiveProfileDataSource {
  final Box<ProfileModel> profileBox;

  HiveProfileDataSource(this.profileBox);

  Future<ProfileModel?> getProfile() async {
    return profileBox.get(AppStrings.kProfileBox);
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await profileBox.put(AppStrings.kProfileBox, profile);
  }
}

