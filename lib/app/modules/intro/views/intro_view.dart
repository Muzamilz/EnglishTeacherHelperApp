import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_xyadoh9h.json',
                height: 200,
              ),
              const SizedBox(height: 40),
              Text(
                'English Teachers Helper',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(),
              const SizedBox(height: 24),
              Text(
                'Your all-in-one solution for classroom management',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(),
              const SizedBox(height: 40),
              _buildFeatureItem(
                context,
                Icons.timer,
                'Time Management',
                'Efficiently manage class time for different teaching stages',
              ),
              _buildFeatureItem(
                context,
                Icons.grade,
                'Grade Management',
                'Calculate and track student grades for various assessments',
              ),
              _buildFeatureItem(
                context,
                Icons.people,
                'Attendance Tracking',
                'Keep track of student attendance with visual analytics',
              ),
              _buildFeatureItem(
                context,
                Icons.auto_stories,
                'Lesson Planning',
                'AI-powered assistance for lesson preparation',
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Get.toNamed('/login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Started'),
              ).animate().fadeIn().scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}
