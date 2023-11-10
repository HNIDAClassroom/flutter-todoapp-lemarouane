import 'package:flutter/material.dart';
import 'package:todolist_app/model/task.dart';
import 'package:todolist_app/services/firestore.dart';

class ModifyTask extends StatefulWidget {
  final Function(Task) onTaskModified;
  final Task task;

  ModifyTask({Key? key, required this.onTaskModified, required this.task}) : super(key: key);

  @override
  State<ModifyTask> createState() {
    return _ModifyTaskState();
  }
}

class _ModifyTaskState extends State<ModifyTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.task.title;
    descriptionController.text = widget.task.description;
    selectedCategory = widget.task.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                maxLength: 50,
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Select a Category:'),
              Column(
                children: Category.values.map((category) {
                  return Row(
                    children: [
                      Checkbox(
                        value: selectedCategory == category,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              selectedCategory = category;
                            }
                          });
                        },
                      ),
                      Text(category.toString().split('.').last),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final title = titleController.text;
                  final description = descriptionController.text;

                  if (title.isNotEmpty && description.isNotEmpty) {
                    final modifiedTask = Task(
                      id: widget.task.id,
                      title: title,
                      description: description,
                      date: widget.task.date,
                      category: selectedCategory ?? Category.other,
                      isDone: widget.task.isDone,
                    );

                    // Update the UI with the modified task first
                    widget.onTaskModified(modifiedTask);

                    // Close the ModifyTask screen
                    Navigator.of(context).pop();

                    // Then update the Firestore data
                    await FirestoreService().updateTask(widget.task.id, {
                      'title': title,
                      'description': description,
                      'category': selectedCategory.toString().split('.').last,
                      'isDone': widget.task.isDone,
                    });
                  } else {
                    // Show an error message or handle the empty fields
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
