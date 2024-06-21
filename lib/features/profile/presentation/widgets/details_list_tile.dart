import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:flutter/services.dart';

class DetailsListTile extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final bool? allowCopy;

  const DetailsListTile({super.key, this.title, this.subTitle, this.allowCopy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          tileColor: AppColors.verLightGray,
          title: Text(
            title ?? "",
            style: font12LightGrayNormal,
          ),
          subtitle: Text(
            subTitle ?? "",
            style: font18VeyDarkBlueBoldWith60Opacity,
          ),
          trailing: allowCopy!
              ? GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: subTitle!));
                  },
                  child: Image.asset(
                    "assets/images/copy.png",
                    height: 24.h,
                    width: 24.h,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
