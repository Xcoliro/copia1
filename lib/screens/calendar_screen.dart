import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TaskProvider _taskProvider;
  List<Task> _selectedDayTasks = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _loadSelectedDayTasks();
  }

  Future<void> _loadSelectedDayTasks() async {
    final tasks = await _taskProvider.getTasksByDate(_selectedDay);
    setState(() {
      _selectedDayTasks = tasks;
    });
  }

  List<Task> _getEventsForDay(DateTime day) {
    return _taskProvider.tasks.where((task) {
      return task.dueDate.year == day.year &&
          task.dueDate.month == day.month &&
          task.dueDate.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              markersMaxCount: 1,
              markersAnchor: 1.7,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _loadSelectedDayTasks();
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  DateFormat('MMMM d, y').format(_selectedDay),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '${_selectedDayTasks.length} tasks',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedDayTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks for this day',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _selectedDayTasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(task: _selectedDayTasks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 