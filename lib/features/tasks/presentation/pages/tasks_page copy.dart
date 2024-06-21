import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';
import 'package:tasky/features/tasks/logic/no_animation_tab_controller.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';
import 'package:tasky/features/tasks/presentation/widgets/floating_action_buttons.dart';
import 'package:tasky/features/tasks/presentation/widgets/tasks_list.dart';
import 'package:tasky/features/tasks/presentation/widgets/tasks_tabBar.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  late NoAnimationTabController _tabController;
  int selectedIndex = 0;
  List<String> tabsTitles = ["All", "In progress", "Waiting", "Finished"];
  final TasksController _tasksController = Get.find<TasksController>();

  @override
  void initState() {
    super.initState();
    _tasksController.init();
    _tabController = NoAnimationTabController(
        // animationDuration: Duration.zero,
        length: tabsTitles.length,
        initialIndex: 0,
        vsync: this);
    _tabController.animation?.addListener(() {
      int indexChange = _tabController.offset.round();
      int index = _tabController.index + indexChange;

      if (index != selectedIndex) {
        setState(() => selectedIndex = index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: const FloatingActionButtons(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 24.h, left: 20.w, right: 18.w),
              child: Text(
                "My Tasks",
                style: font16VeyDarkBlueBoldWith60Opacity,
              ),
            ),
            verticalSpacing(18.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    TasksList(
                      // ignore: invalid_use_of_protected_member
                      taskList: _tasksController.tasks.value,
                      taskController: _tasksController,
                    ),
                    TasksList(
                      taskList: _tasksController.inProgressTasks,
                      taskController: _tasksController,
                    ),
                    TasksList(
                      taskList: _tasksController.waitingTasks,
                      taskController: _tasksController,
                    ),
                    TasksList(
                      taskList: _tasksController.finishedTasks,
                      taskController: _tasksController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    var width = context.mediaQuery.size.width;
    return AppBar(
      titleSpacing: 20,
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(width >= 600 ? 170.h : 70.h),
        child: TasksBody(
          tabController: _tabController,
          selectedIndex: selectedIndex,
          tabsTitles: tabsTitles,
        ),
      ),
      elevation: 0,
      title: Text(
        "Tasky",
        style: width >= 600 ? font14VerDarkGreyMedium : font24VeyDarkBlueBold,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(AppRouter.profile);
          },
          icon: Icon(
            Icons.account_circle_outlined,
            size: 24.h,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.find<AuthController>().logout();
          },
          icon: Image.asset(
            "assets/images/exit_arrow.png",
            height: 24.h,
            width: 24.w,
          ),
          color: AppColors.primaryColor,
        ),
      ],
    );
  }
}
