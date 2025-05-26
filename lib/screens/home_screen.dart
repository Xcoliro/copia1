import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'tasks_screen.dart';
import 'calendar_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const TasksScreen(),
    const CalendarScreen(),
    const StatisticsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load tasks when the app starts
    Future.microtask(() =>
        Provider.of<TaskProvider>(context, listen: false).loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
} 