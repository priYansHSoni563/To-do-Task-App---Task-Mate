import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/utils/app_str.dart';

String lottieURL = 'assets/lottie/1.json';

// Empty Title OR Subtitle TextField warning
dynamic emptyWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You Must fill all fields!",
    corner: 20.0,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}

//  Nothing Entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context) {
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: "You must edit the task then try to update it!",
    corner: 20.0,
    duration: 5000,
    padding: EdgeInsets.all(20),
  );
}

dynamic noTaskWarning(BuildContext context) {
  return PanaraInfoDialog.showAnimatedGrow(
    title: AppStr.oopsMsg,
    context,
    message:
        'There is no task For Delete!\n Try adding some and then try to delete it!',
    buttonText: 'Okey',
    onTapDismiss: () {
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

// Delete all Task from DB Dialog
dynamic deleteAllTask(BuildContext context) {
  return PanaraConfirmDialog.show(context,
      title: AppStr.areYouSure,
      message:
          'Do You really want to delete all tasks? You will no be able to undo this action',
      confirmButtonText: 'Yes',
      cancelButtonText: 'No', onTapConfirm: () {
    // we will clear all box data using this command latar on
    BaseWidget.of(context).dataStore.box.clear();
    Navigator.pop(context);
  }, onTapCancel: () {
    Navigator.pop(context);
  }, panaraDialogType: PanaraDialogType.error, barrierDismissible: false);
}
