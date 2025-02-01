import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: controller.changeTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildStatisticsCards(context),
            const SizedBox(height: 24),
            _buildUpcomingClasses(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    'Welcome, ${controller.teacherName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to make a difference today?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.school,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard(
          context,
          'Lesson Planner',
          Icons.auto_stories,
          () => Get.toNamed('/lesson-planner'),
          Colors.blue,
        ),
        _buildActionCard(
          context,
          'Attendance',
          Icons.people,
          () => Get.toNamed('/attendance'),
          Colors.green,
        ),
        _buildActionCard(
          context,
          'Grades',
          Icons.grade,
          () => Get.toNamed('/grades'),
          Colors.orange,
        ),
        _buildActionCard(
          context,
          'Time Management',
          Icons.timer,
          () => Get.toNamed('/timer'),
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      VoidCallback onTap, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildStatisticsCards(BuildContext context) {
    return Obx(() => Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Students',
            controller.totalStudents.toString(),
            Icons.group,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Average Attendance',
            '${controller.averageAttendance}%',
            Icons.timeline,
            Colors.green,
          ),
        ),
      ],
    ));
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildUpcomingClasses(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Classes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.upcomingClasses.length,
          itemBuilder: (context, index) {
            final classInfo = controller.upcomingClasses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.class_,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(classInfo.className),
                subtitle: Text(classInfo.time),
                trailing: Text(
                  classInfo.duration,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ).animate().fadeIn().slideX();
          },
        )),
      ],
    );
  }
}
