import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/models/task.dart';

// All the (CURD) operation method fro Hive DB
class HiveDataStore {
  // Box Name - String
  static const boxName = 'TaskBox';

  // Our current Box wiht all the Saved data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  // Add New Task to Box
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  // Show Task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  // Update Task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  // delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  // Listen Box Changes
  // using this method we will listen to box change and update the UI accordingly
  ValueListenable<Box<Task>> listenToTaks() => box.listenable();
}
