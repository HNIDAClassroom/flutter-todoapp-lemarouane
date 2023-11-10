import 'package:flutter/material.dart';
import 'package:todolist_app/model/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/widgets/modify_task.dart';

class TaskItem extends StatefulWidget {
  Task task;
  TaskItem(this.task, {Key? key}) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final IconData categoryIcon = getCategoryIcon(widget.task.category);
    final Color backgroundColor = widget.task.isDone ? Colors.grey : Colors.white;

    return Card(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(categoryIcon, color: getCategoryColor(widget.task.category)),
        title: Text(
          widget.task.title,
          style: TextStyle(
            decoration: widget.task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.description),
            Text(
              'Date: ${widget.task.date.toLocal()}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: widget.task.isDone,
              onChanged: (newValue) async {
                // Update the Firestore data when the task is checked
                await FirestoreService().updateTaskIsDone(widget.task.id, newValue!);

                setState(() {
                  widget.task.isDone = newValue;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final updatedTask = await showModalBottomSheet<Task>(
                  context: context,
                  builder: (context) {
                    return ModifyTask(
                      onTaskModified: (modifiedTask) {
                        // Update the UI with the modified task
                        setState(() {
                          widget.task = modifiedTask;
                        });
                      },
                      task: widget.task,
                    );
                  },
                );

                // Update the Firestore data if the task is updated
                if (updatedTask != null) {
                  await FirestoreService().updateTask(updatedTask.id, {
                    'title': updatedTask.title,
                    'description': updatedTask.description,
                    'category': updatedTask.category.toString().split('.').last,
                    'isDone': updatedTask.isDone,
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete the task using its ID
                FirestoreService().deleteTask(widget.task.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData getCategoryIcon(Category category) {
    switch (category) {
      case Category.personal:
        return Icons.person;
      case Category.work:
        return Icons.work;
      case Category.study:
        return Icons.school;
      case Category.other:
        return Icons.assignment;
    }
  }

  Color getCategoryColor(Category category) {
    switch (category) {
      case Category.personal:
        return Colors.blue;
      case Category.work:
        return Colors.green;
      case Category.study:
        return Colors.orange;
      case Category.other:
        return Colors.grey;
    }
  }
}
