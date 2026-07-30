import 'package:flutter/material.dart';
class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});
  @override Widget build(BuildContext context) {
    final days = List.generate(30, (i) => i < 5 ? true : false);
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(title: const Text('\u0627\u0633\u062A\u0645\u0631\u0627\u0631\u064A\u062A\u064A',style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('\uD83D\uDD25', style: TextStyle(fontSize: 64)),
        const SizedBox(height: 8),
        const Text('5 \u0623\u064A\u0627\u0645 \u0645\u062A\u062A\u0627\u0644\u064A\u0629', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('\u0623\u062D\u0633\u0646\u062A! \u0627\u0633\u062A\u0645\u0631', style: TextStyle(color: Colors.white.withOpacity(0.6))),
        const SizedBox(height: 32),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
          child: Wrap(spacing: 6, runSpacing: 6, children: days.map((d) => Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: d ? const Color(0xFF6C63FF) : Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(d ? '\u2713' : '\u00B7', style: TextStyle(color: d ? Colors.white : Colors.white24))),
          )).toList()),
        ),
      ])),
    );
  }
}