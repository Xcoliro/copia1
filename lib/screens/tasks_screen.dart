import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_dialog.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.task_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTaskDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 