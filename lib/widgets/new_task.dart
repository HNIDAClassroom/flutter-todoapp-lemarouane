import 'package:flutter/material.dart';
import 'package:todolist_app/model/task.dart';

class NewTask extends StatefulWidget {
  final Function(Task) onTaskSaved;

  const NewTask({Key? key, required this.onTaskSaved}) : super(key: key);

  @override
  State<NewTask> createState() {
    return _NewTaskState();
  }
}

class _NewTaskState extends State<NewTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        backgroundColor: Colors.blue, // Customize the app bar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: titleController,
                labelText: 'Title',
                maxLength: 50,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: descriptionController,
                labelText: 'Description',
                maxLines: 3, // Allowing multiline description
              ),
              const SizedBox(height: 16),
              const Text(
                'Select a Category:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildCategoryCheckboxes(),
              const SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLength = 100,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryCheckboxes() {
    return Column(
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
            Text(
              category.toString().split('.').last,
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        final title = titleController.text;
        final description = descriptionController.text;

        if (title.isNotEmpty && description.isNotEmpty) {
          final newTask = Task(
            title: title,
            description: description,
            date: selectedDate,
            category: selectedCategory ?? Category.other,
            id: '',
          );

          widget.onTaskSaved(newTask);
        } else {
          // Show an error message or handle the empty fields
        }
      },
      child: const Text('Save Task'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Set button color
        textStyle: TextStyle(fontSize: 18), // Adjust text size
      ),
    );
  }
}
