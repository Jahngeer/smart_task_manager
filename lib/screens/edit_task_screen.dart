import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController controller;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.task.title);
    selectedDate = widget.task.date.isNotEmpty
        ? DateTime.parse(widget.task.date)
        : null;
  }

  void pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void updateTask() async {
    widget.task.title = controller.text;
    widget.task.date = selectedDate != null
        ? selectedDate.toString().split(' ')[0]
        : "";

    await DBHelper.instance.updateTask(widget.task);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Task")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Task"),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Text(selectedDate == null
                    ? "No Date"
                    : selectedDate.toString().split(' ')[0]),

                const Spacer(),

                TextButton(
                  onPressed: pickDate,
                  child: const Text("Change Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateTask,
              child: const Text("Update Task"),
            )
          ],
        ),
      ),
    );
  }
}