import 'package:flutter/material.dart';
import 'views/breathing/breathing_view.dart';
import 'views/mood/mood_tracker_view.dart';
import 'views/soundscapes/soundscapes_view.dart';
import 'views/journal/journal_view.dart';
import 'views/streak/streak_view.dart';
import 'views/courses/courses_view.dart';
import 'views/tests/tests_view.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Start',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F0F23),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
      ),
    ),
    builder: (context, child) => Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    ),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0F0F23),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Start',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'رحلة التأمل والتنفس',
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(height: 32),
            Expanded(child: _buildGrid(context)),
          ],
        ),
      ),
    ),
  );

  Widget _buildGrid(BuildContext context) {
    final emojis = ['🧘', '😊', '🎵', '📝', '🔥', '📚', '🧪'];
    final labels = ['تمارين التنفس', 'مزاجي', 'أصوات', 'مذكرات', 'الاستمرارية', 'دورات', 'اختبارات'];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1,
      children: List.generate(7, (i) => GestureDetector(
        onTap: () => _navigate(context, i),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emojis[i], style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(labels[i], style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      )),
    );
  }

  void _navigate(BuildContext context, int i) {
    final screens = <Widget>[
      const BreathingScreen(),
      const MoodTrackerScreen(),
      const SoundscapesScreen(),
      const JournalScreen(),
      const StreakScreen(),
      const CoursesScreen(),
      const TestsScreen(),
    ];
    Navigator.push(context, MaterialPageRoute(builder: (_) => screens[i]));
  }
}
