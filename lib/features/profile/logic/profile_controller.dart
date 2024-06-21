import 'package:get/get.dart';
import 'package:tasky/core/helpers/app_snackbar.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';
import 'package:tasky/features/profile/data/repositories/profile_repository.dart';

class ProfileController extends GetxController {

  final _profile = Rxn<ProfileModel>();

  Rxn<ProfileModel> get profile => _profile;

  var isLoading = false.obs;

  final ProfileRepository repository;

  ProfileController(this.repository);

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      var response = await repository.getProfile();
      response.when(success: (ProfileModel profileModel){
        profile.value = profileModel;
        isLoading.value = false;
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
      }, error: (ErrorModel error) {
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);

      });
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

}