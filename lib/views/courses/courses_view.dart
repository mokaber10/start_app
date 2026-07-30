import "package:flutter/material.dart";
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});
  @override State<CoursesScreen> createState() => _C();
}
class _C extends State<CoursesScreen> {
  final List<Map<String,dynamic>> cs = const [
    {"t":"\u0627\u0644\u062A\u0623\u0645\u0644 \u0644\u0644\u0645\u0628\u062A\u062F\u0626\u064A\u0646","l":7,"e":"\uD83E\uDDD8","c":Color(0xFF6C63FF)},
    {"t":"\u062A\u0645\u0627\u0631\u064A\u0646 \u0627\u0644\u062A\u0646\u0641\u0633","l":5,"e":"\uD83C\uDF2C\uFE0F","c":Color(0xFF00BFA5)},
    {"t":"\u0627\u0644\u0646\u0648\u0645 \u0627\u0644\u0639\u0645\u064A\u0642","l":6,"e":"\uD83D\uDE34","c":Color(0xFF4A0080)},
    {"t":"\u0627\u0644\u062A\u0631\u0643\u064A\u0632 \u0627\u0644\u0630\u0647\u0646\u064A","l":8,"e":"\uD83C\uDFAF","c":Color(0xFFFF6B00)},
    {"t":"\u0625\u062F\u0627\u0631\u0629 \u0627\u0644\u062A\u0648\u062A\u0631","l":6,"e":"\uD83E\uDDE0","c":Color(0xFF00BCD4)},
    {"t":"\u0627\u0644\u064A\u0642\u0638\u0629 \u0627\u0644\u0630\u0647\u0646\u064A\u0629","l":10,"e":"\uD83C\uDF3F","c":Color(0xFF2E8B57)},
    {"t":"\u0627\u0644\u0635\u062D\u0648\u0629 \u0627\u0644\u0635\u0628\u0627\u062D\u064A\u0629","l":4,"e":"\u2600\uFE0F","c":Color(0xFFFFA000)},
  ];
  @override Widget build(BuildContext c) => Scaffold(
    backgroundColor: const Color(0xFF0F0F23),
    appBar: AppBar(title: const Text("\u0627\u0644\u062F\u0648\u0631\u0627\u062A",style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
    body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: cs.length,
      itemBuilder: (_,i) => Container(
        margin: const EdgeInsets.only(bottom:12), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: (cs[i]["c"] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: (cs[i]["c"] as Color).withOpacity(0.2))),
        child: Row(children: [
          Text(cs[i]["e"] as String, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cs[i]["t"] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("\u200E${cs[i]["l"]} \u062F\u0631\u0648\u0633", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
          ])),
          Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.3)),
        ]),
      ),
    ),
  );
}