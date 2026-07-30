import 'package:flutter/material.dart';
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
    title: 'Start', debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0F0F23), colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark)),
    home: const HomeScreen(),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final _items = const [
    ('🧘', 'تمارين التنفس'),
    ('😊', 'مزاجي'),
    ('🎵', 'أصوات'),
    ('📝', 'مذكرات'),
    ('🔥', 'الاستمرارية'),
    ('📚', 'دورات'),
    ('🧪', 'اختبارات'),
  ];
  void _open(BuildContext c, int i) {
    final pages = [
      null,
      const MoodTrackerScreen(), const SoundscapesScreen(), const JournalScreen(),
      const StreakScreen(), const CoursesScreen(), const TestsScreen(),
    ];
    if (i > 0 && pages[i] != null) Navigator.push(c, MaterialPageRoute(builder: (_) => pages[i]!));
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      Text('Start', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 8),
      Text('رحلة التأمل والتنفس', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6))),
      const SizedBox(height: 32),
      Expanded(child: GridView.count(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1,
        children: List.generate(_items.length, (i) => GestureDetector(
          onTap: () => _open(context, i),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_items[i].$1, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(_items[i].$2, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ]),
          ),
        )),
      )),
    ]),
  )));
}
