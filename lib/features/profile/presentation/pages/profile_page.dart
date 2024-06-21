import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/features/profile/logic/profile_controller.dart';
import 'package:tasky/features/profile/presentation/widgets/details_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 24.w),
        child: SafeArea(
          child: Obx(() {
            if (Get.find<ProfileController>().isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (Get.find<ProfileController>().profile.value == null) {
              return const Center(child: Text('Failed to load profile'));
            } else {
              final profile = Get.find<ProfileController>().profile.value!;
              return ListView(children: [
                DetailsListTile(
                  title: "NAME",
                  subTitle: profile.displayName,
                  allowCopy: false,
                ),
                DetailsListTile(
                  title: "PHONE",
                  subTitle: profile.username,
                  allowCopy: true,
                ),
                DetailsListTile(
                  title: "LEVEL",
                  subTitle: profile.level,
                  allowCopy: false,
                ),
                DetailsListTile(
                  title: "YEARS OF EXPERIENCE",
                  subTitle: "${profile.experienceYears} Years",
                  allowCopy: false,
                ),
                DetailsListTile(
                  title: "LOCATION",
                  subTitle: profile.address,
                  allowCopy: false,
                ),
              ]);
            }
          }),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Image.asset(
          "assets/images/arrow_left.png",
          width: 24.h,
          height: 24.h,
        ),
        onPressed: () => context.navigator.pop(),
      ),
      title: AppText(
        "Profile",
        style: font16VeyDarkBlueBold,
      ),
    );
  }
}
