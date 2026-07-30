import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});
  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  String? _selectedMood;
  final List<Map<String, dynamic>> _moods = const [
    {'emoji': '😊', 'name': 'سعيد', 'color': Color(0xFFFFD700)},
    {'emoji': '😌', 'name': 'مرتاح', 'color': Color(0xFF98FB98)},
    {'emoji': '😐', 'name': 'محايد', 'color': Color(0xFFD3D3D3)},
    {'emoji': '😢', 'name': 'حزين', 'color': Color(0xFF87CEEB)},
    {'emoji': '😠', 'name': 'غاضب', 'color': Color(0xFFFF6B6B)},
    {'emoji': '😰', 'name': 'قلق', 'color': Color(0xFFDDA0DD)},
    {'emoji': '😴', 'name': 'متعب', 'color': Color(0xFFB0C4DE)},
    {'emoji': '🙏', 'name': 'ممتن', 'color': Color(0xFF90EE90)},
    {'emoji': '💪', 'name': 'متحمس', 'color': Color(0xFFFFA07A)},
    {'emoji': '🧘', 'name': 'مركز', 'color': Color(0xFFE6E6FA)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(title: const Text('مزاجي اليوم', style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Wrap(
        spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
        children: _moods.map((m) => GestureDetector(
          onTap: () => setState(() => _selectedMood = m['name'] as String),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80, height: 100,
            decoration: BoxDecoration(
              color: _selectedMood == m['name'] ? (m['color'] as Color).withOpacity(0.3) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _selectedMood == m['name'] ? m['color'] as Color : Colors.white.withOpacity(0.1), width: _selectedMood == m['name'] ? 2 : 1),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(m['emoji'] as String, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 4),
              Text(m['name'] as String, style: TextStyle(color: _selectedMood == m['name'] ? Colors.white : Colors.white60, fontSize: 12)),
            ]),
          ),
        )).toList(),
      ))),
    );
  }
}