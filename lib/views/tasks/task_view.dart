import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extension/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/date_time_selection.dart';
import 'package:todo_app/views/home/widgets/task_view_app_bar.dart';
import '../home/components/rep_textfield.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  // Show Selected Time as String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  // show Selected Date as DateFormate for init Time
  DateTime showDateAsDatetime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  // Show Selected Date as String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtTime).toString();
    }
  }

  // if any task Already Exist return ture otherwise false
  bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    // Here WE Update Current Task
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subtitle;
        widget.task?.save();

        Navigator.pop(context);
      } catch (e) {
        // If user  want to update task but entered nothing we will show this warning
        updateTaskWarning(context);
      }
    }

    // Here we Create a New Task
    else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          subtitle: subtitle,
          createdAtDate: date,
          createdAtTime: time,
        );

        // We are adding this new task to Hive DB using inherited widget
        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        //Warning
        emptyWarning(context);
      }
    }
  }

  // Delete Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        // App BAr
        appBar: TaskViewAppBar(),


        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // top Side Texts
                _buildTopSideTexts(textTheme),

                _buildMainTaskViewAcitivity(
                  textTheme,
                  context,
                ),

                // Bottom Side Button
                _buildBottomSideButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExist()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExist()
              ? Container()
              :
              // Delete Current Task Button
              MaterialButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  height: 55,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: AppColors.primaryColor,
                      ),
                      5.w,
                      Text(
                        AppStr.deleteTask,
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
          // Add or Update Task
          MaterialButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              // Add or Update Task Acitivity
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            height: 55,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text(
                  isTaskAlreadyExist()
                      ? AppStr.addTaskString
                      : AppStr.updateTaskString,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Main Task View Acitivity
  Widget _buildMainTaskViewAcitivity(
      TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of TextField
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          // Task Title
          RepTextField(
            controller: widget.titleTaskController,
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),
          10.h,
          // Task Title
          RepTextField(
            controller: widget.descriptionTaskController,
            isforDescription: true,
            onFieldSubmitted: (String inputSubtitle) {
              subtitle = inputSubtitle;
            },
            onChanged: (String inputSubtitle) {
              subtitle = inputSubtitle;
            },
          ),

          // Time Selection
          DateTimeSelectionWidget(
            ontap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 280,
                  child: DateTimePickerWidget(
                    initDateTime: showDateAsDatetime(time),
                    onChange: (_, __) {},
                    dateFormat: "HH:mm",
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString,
            // for testing
            time: showTime(time),
          ),

          // Date Selection
          DateTimeSelectionWidget(
            ontap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2050, 4, 5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDatetime(date),
                onConfirm: (dateTime, _) {
                  // will complete this part upcoming part as well
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,
            isTime: true,
            // for testing
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  // Top Side Texts
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Divider Grey
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),

          // latter on according to the tasks condition we will decide to "ADD NEW TASK" or "UPDATE CURRENT TASK"
          // task
          RichText(
            text: TextSpan(
              text: isTaskAlreadyExist()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
              style: textTheme.titleLarge,
              children: [
                TextSpan(
                  text: AppStr.taskString,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Divider Grey
          SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
