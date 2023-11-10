import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_app/model/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  TasksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getTasks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingWidget();
              }

              final taskItems = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final taskId = doc.id;
                final title = data['title'];
                final description = data['description'];
                final date = (data['date'] as Timestamp).toDate();
                final categoryString = data['category'];
                Category category = Category.other;

                if (categoryString == 'personal') {
                  category = Category.personal;
                } else if (categoryString == 'work') {
                  category = Category.work;
                } else if (categoryString == 'study') {
                  category = Category.study;
                }

                final isDone = data['isDone'] ?? false;

                return Task(
                  id: taskId,
                  title: title,
                  description: description,
                  date: date,
                  category: category,
                  isDone: isDone,
                );
              }).toList();

              return _buildTaskListView(taskItems);
            },
          ),
        ),
        _buildButtons(),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text(
        'Error: $error',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTaskListView(List<Task> taskItems) {
    return ListView.builder(
      itemCount: taskItems.length,
      itemBuilder: (context, index) {
        Task task = taskItems[index];
        return TaskItem(task);
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            // Implement the functionality for the first button
          },
          child: Text('Button 1'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement the functionality for the second button
          },
          child: Text('Button 2'),
        ),
      ],
    );
  }
}
