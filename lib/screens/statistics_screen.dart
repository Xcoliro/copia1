import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final completedTasks = taskProvider.completedTasksCount;
          final pendingTasks = taskProvider.pendingTasksCount;
          final completionRate = taskProvider.completionRate;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(
                  completedTasks,
                  pendingTasks,
                  completionRate,
                ),
                const SizedBox(height: 24),
                Text(
                  'Task Completion',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildCompletionChart(completedTasks, pendingTasks),
                const SizedBox(height: 24),
                Text(
                  'Progress Overview',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildProgressBar(completionRate),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(
    int completedTasks,
    int pendingTasks,
    double completionRate,
  ) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Completed',
            value: completedTasks.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Pending',
            value: pendingTasks.toString(),
            icon: Icons.pending_actions,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionChart(int completed, int pending) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: completed.toDouble(),
              title: 'Completed',
              color: Colors.green,
              radius: 80,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            PieChartSectionData(
              value: pending.toDouble(),
              title: 'Pending',
              color: Colors.orange,
              radius: 80,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 0,
        ),
      ),
    );
  }

  Widget _buildProgressBar(double completionRate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Completion: ${completionRate.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completionRate / 100,
            minHeight: 20,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
} 