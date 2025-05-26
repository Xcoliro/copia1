import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'edit_task_dialog.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Dismissible(
      key: Key(task.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        taskProvider.deleteTask(task);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${task.title} deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                taskProvider.addTask(task);
              },
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (bool? value) {
              taskProvider.toggleTaskCompletion(task);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.description),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, y').format(task.dueDate),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (task.reminderDateTime != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.alarm, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('h:mm a').format(task.reminderDateTime!),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => EditTaskDialog(task: task),
              );
            },
          ),
        ),
      ),
    );
  }
} 