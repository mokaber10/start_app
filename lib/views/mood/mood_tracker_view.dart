import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerScreen extends ConsumerStatefulWidget {
  const MoodTrackerScreen({super.key});
  @override
  ConsumerState<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends ConsumerState<MoodTrackerScreen> {
  String? _selectedMood;
  List<Map<String, dynamic>> _history = [];

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
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('mood_history');
    if (saved != null) {
      final decoded = jsonDecode(saved) as List;
      setState(() {
        _history = decoded.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _selectMood(String name, String emoji) async {
    HapticFeedback.mediumImpact();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final entry = {'date': today, 'mood': name, 'emoji': emoji};

    setState(() {
      _selectedMood = name;
      _history.insert(0, entry);
      if (_history.length > 30) _history = _history.sublist(0, 30);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mood_history', jsonEncode(_history));
  }

  // Get mood color by name
  Color _moodColor(String name) {
    for (final m in _moods) {
      if (m['name'] == name) return m['color'] as Color;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    // Get today's mood from history
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final todayEntry = _history.where((e) => e['date'] == today).isNotEmpty;
    final showSelected = todayEntry && _selectedMood != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text('مزاجي اليوم', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood grid
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: _moods.map((m) => GestureDetector(
                  onTap: () => _selectMood(m['name'] as String, m['emoji'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _selectedMood == m['name']
                          ? (m['color'] as Color).withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedMood == m['name']
                            ? m['color'] as Color
                            : Colors.white.withOpacity(0.1),
                        width: _selectedMood == m['name'] ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(m['emoji'] as String, style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 4),
                        Text(
                          m['name'] as String,
                          style: TextStyle(
                            color: _selectedMood == m['name'] ? Colors.white : Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),

              if (showSelected) ...[
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: _moodColor(_selectedMood!).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _moodColor(_selectedMood!).withOpacity(0.3)),
                    ),
                    child: Text(
                      '$_selectedMood $_selectedMood',
                      style: TextStyle(color: _moodColor(_selectedMood!), fontSize: 16),
                    ),
                  ),
                ),
              ],

              // History
              if (_history.isNotEmpty) ...[
                const SizedBox(height: 32),
                const Text(
                  'آخر 7 أيام',
                  style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _history.length > 7 ? 7 : _history.length,
                  (i) {
                    final e = _history[i];
                    final date = e['date'] as String;
                    final mood = e['mood'] as String;
                    final emoji = e['emoji'] as String;
                    // Format date: today vs date
                    final isToday = date == today;
                    final label = isToday ? 'اليوم' : date.substring(5);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              mood,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                          Text(
                            label,
                            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
