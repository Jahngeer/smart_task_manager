import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import '../models/task.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  String search = "";
  final controller = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Tasks ko database se load karne ke liye
  void loadTasks() async {
    final data = await DBHelper.instance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  // Naya Task add karne ke liye
  void addTask() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task title")),
      );
      return;
    }

    final newTask = Task(
      title: controller.text.trim(),
      isDone: false, // Default false
      date: selectedDate != null
          ? selectedDate.toString().split(' ')[0]
          : DateTime.now().toString().split(' ')[0], // Default aaj ki date
    );

    await DBHelper.instance.insertTask(newTask);

    setState(() {
      controller.clear();
      selectedDate = null;
    });
    loadTasks();
  }

  void toggleTask(Task task) async {
    task.isDone = !task.isDone;
    await DBHelper.instance.updateTask(task);
    loadTasks();
  }

  void deleteTask(int id) async {
    await DBHelper.instance.deleteTask(id);
    loadTasks();
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

  @override
  Widget build(BuildContext context) {
    // Search filter logic
    final filteredTasks = tasks.where((task) {
      return task.title.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Task Manager"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 SEARCH + ADD SECTION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // SEARCH FIELD
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => search = ""),
                          )
                        : null,
                  ),
                  onChanged: (value) => setState(() => search = value),
                ),
                const SizedBox(height: 12),
                // ADD TASK ROW
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Enter task name...",
                          prefixIcon: Icon(Icons.add_task),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.calendar_month,
                        color: selectedDate != null
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: pickDate,
                    ),
                    ElevatedButton(
                      onPressed: addTask,
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 📋 TASK LIST
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text("No tasks found!"))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) => toggleTask(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(task.date),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditTaskScreen(task: task),
                                    ),
                                  );
                                  loadTasks();
                                },
                              ),
                              // Trailing section mein delete icon ko is se replace karein:
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // 🔔 Alert Dialog yahan show hoga
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete Task?"),
                                        content: const Text(
                                          "Are you sure you want to delete this task?",
                                        ),
                                        actions: [
                                          // Cancel Button
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancel"),
                                          ),
                                          // Confirm Delete Button
                                          TextButton(
                                            onPressed: () {
                                              deleteTask(
                                                task.id!,
                                              ); // Task delete function call
                                              Navigator.pop(
                                                context,
                                              ); // Dialog band karein

                                              // Optional: Chota sa message niche show karne ke liye
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Task deleted!",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                             "Yes, Delete it",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
