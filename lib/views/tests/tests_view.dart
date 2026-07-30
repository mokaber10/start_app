import "package:flutter/material.dart";
class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});
  @override State<TestsScreen> createState() => _T();
}
class _T extends State<TestsScreen> {
  int _q = 0, _s = 0;
  bool _r = false;
  final List<Map> _qs = const [
    {"q":"\u0645\u0627 \u0647\u0648 \u0623\u0641\u0636\u0644 \u0648\u0635\u0641 \u0644\u062D\u0627\u0644\u062A\u0643 \u0627\u0644\u0622\u0646\u061F","o":["\u0647\u0627\u062F\u0626","\u0645\u062A\u0648\u062A\u0631","\u0633\u0639\u064A\u062F","\u0645\u062A\u0639\u0628"],"a":0},
    {"q":"\u0643\u0645 \u0645\u0631\u0629 \u062A\u0634\u0639\u0631 \u0628\u0627\u0644\u0627\u0645\u062A\u0646\u0627\u0646 \u0623\u0633\u0628\u0648\u0639\u064A\u0627\u061F","o":["\u064A\u0648\u0645\u064A\u0627\u064B","\u0623\u062D\u064A\u0627\u0646\u0627\u064B","\u0646\u0627\u062F\u0631\u0627\u064B","\u0623\u0628\u062F\u0627\u064B"],"a":0},
  ];
  void _a(int i) {
    if(_q < _qs.length-1) { setState((){ if(i==_qs[_q]["a"]) _s++; _q++; }); }
    else { setState((){ if(i==_qs[_q]["a"]) _s++; _r=true; }); }
  }
  @override Widget build(BuildContext c) => Scaffold(
    backgroundColor: const Color(0xFF0F0F23),
    appBar: AppBar(title: Text(_r?"\u0627\u0644\u0646\u062A\u064A\u062C\u0629":"\u0627\u062E\u062A\u0628\u0627\u0631",style: const TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
    body: Center(child: _r
      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("\uD83E\uDDE0", style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text("\u0646\u062A\u064A\u062C\u062A\u0643: $_s/${_qs.length}", style: const TextStyle(color: Colors.white, fontSize: 32)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => setState((){ _q=0; _s=0; _r=false; }), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            child: const Text("\u0625\u0639\u0627\u062F\u0629", style: TextStyle(color: Colors.white))),
        ])
      : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("\u0627\u0644\u0633\u0624\u0627\u0644 ${_q+1}/${_qs.length}", style: TextStyle(color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(24), margin: const EdgeInsets.symmetric(horizontal:20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20)),
            child: Text(_qs[_q]["q"] as String, style: const TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center)),
          const SizedBox(height: 24),
          ...(_qs[_q]["o"] as List).map((opt) => Padding(padding: const EdgeInsets.symmetric(horizontal:20, vertical:4),
            child: SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () => _a((_qs[_q]["o"] as List).indexOf(opt)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.08), padding: const EdgeInsets.symmetric(vertical:14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text(opt as String, style: const TextStyle(color: Colors.white, fontSize: 16)),
            )))).toList(),
        ])),
  );
}