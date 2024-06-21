import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tasky/features/profile/data/adapters/profile_model_adapter.dart';
import 'package:tasky/features/profile/data/data_sources/hive_profile_data_source.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';
import 'package:tasky/features/profile/data/repositories/profile_repository.dart';
import 'package:tasky/features/profile/logic/profile_controller.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ProfileBindings implements Bindings {
  @override
  void dependencies() async {
    var directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ProfileModelAdapter()); // Register the adapter

    final profileBox = await Hive.openBox<ProfileModel>('profileBox');
    // Set up data sources
    final hiveProfileDataSource = HiveProfileDataSource(profileBox);

    // Set up repository
    final connectivity = Connectivity();

    Get.lazyPut<ProfileRepository>(
        () =>
            ProfileRepository(Get.find(), hiveProfileDataSource, connectivity),
        fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find()),
        fenix: true);
  }
}
