import 'package:flutter/material.dart';

class SoundscapesScreen extends StatelessWidget {
  const SoundscapesScreen({super.key});

  final List<Map<String, dynamic>> _albums = const [
    {'name': '🧘 تأمل', 'color': Color(0xFF6C63FF), 'tracks': 8},
    {'name': '😴 نوم عميق', 'color': Color(0xFF4A0080), 'tracks': 10},
    {'name': '🌿 طبيعة', 'color': Color(0xFF2E8B57), 'tracks': 9},
    {'name': '🎵 آلية', 'color': Color(0xFFB8860B), 'tracks': 12},
    {'name': '💧 ماء', 'color': Color(0xFF1E90FF), 'tracks': 7},
    {'name': '🔥 نار', 'color': Color(0xFFFF4500), 'tracks': 6},
    {'name': '🌙 استرخاء', 'color': Color(0xFF2F4F4F), 'tracks': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(title: const Text('أصوات الخلفية', style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: _albums.length,
        itemBuilder: (_, i) {
          final a = _albums[i];
          return Container(
            decoration: BoxDecoration(color: (a['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: (a['color'] as Color).withOpacity(0.3))),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(a['name'] as String, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text('${a['tracks']} مقطع', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            ]),
          );
        },
      ),
    );
  }
}