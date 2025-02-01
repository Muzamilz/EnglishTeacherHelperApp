import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/grade.dart';
import '../controllers/grades_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class GradesView extends GetView<GradesController> {
  const GradesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGradeDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGradeDistributionChart(context),
            const SizedBox(height: 24),
            _buildGradesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDistributionChart(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Grade Distribution',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Obx(() => BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barGroups: controller.gradeDistribution
                      .asMap()
                      .entries
                      .map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: Theme.of(context).primaryColor,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final categories = ['A', 'B', 'C', 'D', 'F'];
                          return Text(
                            categories[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              )),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildGradesList(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Student Grades',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                PopupMenuButton<String>(
                  onSelected: controller.filterByComponent,
                  itemBuilder: (context) => [
                    'All',
                    'Grammar',
                    'Reading',
                    'Writing',
                  ].map((component) => PopupMenuItem(
                    value: component,
                    child: Text(component),
                  )).toList(),
                  child: Chip(
                    label: Obx(() => Text(controller.currentFilter.value)),
                    avatar: const Icon(Icons.filter_list),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.filteredGrades.length,
              itemBuilder: (context, index) {
                final grade = controller.filteredGrades[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getGradeColor(grade.score),
                      child: Text(
                        grade.score.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(grade.studentName),
                    subtitle: Text(grade.component),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditGradeDialog(context, grade),
                    ),
                  ),
                ).animate().fadeIn().slideX();
              },
            )),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  void _showAddGradeDialog(BuildContext context) {
    final studentController = TextEditingController();
    final scoreController = TextEditingController();
    String selectedComponent = 'Grammar';

    Get.dialog(
      AlertDialog(
        title: const Text('Add New Grade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: studentController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedComponent,
              items: ['Grammar', 'Reading', 'Writing']
                  .map((component) => DropdownMenuItem(
                    value: component,
                    child: Text(component),
                  ))
                  .toList(),
              onChanged: (value) => selectedComponent = value!,
              decoration: const InputDecoration(
                labelText: 'Component',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              decoration: const InputDecoration(
                labelText: 'Score',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (studentController.text.isNotEmpty &&
                  scoreController.text.isNotEmpty) {
                controller.addGrade(
                  studentController.text,
                  selectedComponent,
                  int.parse(scoreController.text),
                );
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditGradeDialog(BuildContext context, Grade grade) {
    final scoreController = TextEditingController(text: grade.score.toString());

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Grade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Student: ${grade.studentName}'),
            Text('Component: ${grade.component}'),
            const SizedBox(height: 16),
            TextField(
              controller: scoreController,
              decoration: const InputDecoration(
                labelText: 'New Score',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (scoreController.text.isNotEmpty) {
                controller.updateGrade(
                  grade.id,
                  int.parse(scoreController.text),
                );
                Get.back();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
