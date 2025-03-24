import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/extension/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/widgets/task_widget.dart';
import 'package:todo_app/views/tasks/task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // check view of circle indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  // check Done Task
  int checkDoneTask(List<Task> tasks) {
    HapticFeedback.mediumImpact();
    int i = 0;
    for (Task donTask in tasks) {
      if (donTask.inCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    var alldelete = BaseWidget.of(context).dataStore.box;
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTaks(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          // for sorting list
          tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate));
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              actions: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    alldelete.isEmpty
                        ? noTaskWarning(context)
                        : deleteAllTask(context);
                  },
                  icon: Icon(
                    CupertinoIcons.trash_fill,
                    size: 30,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.grey[200],

            // FAB
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primaryColor,
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => TaskView(
                      titleTaskController: null,
                      descriptionTaskController: null,
                      task: null,
                    ),
                  ),
                );
              },
              child: Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
            ),

            //  Body
            body: _buildHomeBody(
              textTheme,
              base,
              tasks,
            ),
          );
        });
  }

  // Home Body
  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return Column(
      children: [
        //  Custom App Bar
        Container(
          margin: EdgeInsets.only(top: 60),
          width: double.infinity,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress Indicator
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.primaryColor,
                  ),
                ),
              ),
              25.w,

              // Top Level Task Info
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStr.mainTitle,
                    style: textTheme.displayLarge,
                  ),
                  3.h,
                  Text(
                    "${checkDoneTask(tasks)} of ${tasks.length} tasks",
                    style: textTheme.titleMedium,
                  ),
                ],
              )
            ],
          ),
        ),

        // Divider
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Divider(
            thickness: 2,
            indent: 100,
          ),
        ),

        // Tasks
        SizedBox(
          width: double.infinity,
          height: 650,
          child: tasks.isNotEmpty

              // task list is not empty
              ? ListView.builder(
                  itemCount: tasks.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    // Get single Tasks fro showing in list
                    var task = tasks[index];
                    return Dismissible(
                      onDismissed: (_) {
                        // We will remove task from DB
                        base.dataStore.deleteTask(task: task);
                      },
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outlined,
                            color: Colors.grey,
                          ),
                          8.h,
                          Text(
                            AppStr.deletedTask,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      key: Key(
                        task.id,
                      ),
                      child: TaskWidget(task: task),
                    );
                  },
                )

              // task list is empty
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie Animation
                    FadeIn(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          lottieURL,
                          animate: tasks.isNotEmpty ? false : true,
                        ),
                      ),
                    ),
                    FadeInUp(
                      from: 30,
                      child: Text(AppStr.doneAllTask),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
