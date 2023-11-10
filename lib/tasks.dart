import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_app/model/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/tasks_list.dart';
import 'package:todolist_app/widgets/new_task.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: TasksList(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Flutter ToDoList'),
      actions: [
        _buildAddButton(),
        _buildLogoutButton(),
      ],
    );
  }

  IconButton _buildAddButton() {
    return IconButton(
      onPressed: () {
        _openAddTaskOverlay(context);
      },
      icon: const Icon(Icons.add, color: Colors.black),
    );
  }

  IconButton _buildLogoutButton() {
    return IconButton(
      onPressed: _logout,
      icon: const Icon(Icons.logout, color: Colors.black),
    );
  }

  void _openAddTaskOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return NewTask(onTaskSaved: _handleTaskSaved);
      },
    );
  }

  void _handleTaskSaved(Task task) async {
    final taskId = await FirestoreService().addTask(task);
    task.id = taskId;
    Navigator.of(context).pop();
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
