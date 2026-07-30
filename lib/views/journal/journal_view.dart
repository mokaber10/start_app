import 'package:flutter/material.dart';
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override State<JournalScreen> createState() => _JournalScreenState();
}
class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _c = TextEditingController();
  final List<Map<String,dynamic>> _es = [];
  @override void dispose() { _c.dispose(); super.dispose(); }
  void _sv() { if(_c.text.trim().isEmpty) return; setState((){ _es.insert(0,{'x':_c.text,'d':DateTime.now()}); _c.clear(); }); }
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0F0F23),
    appBar: AppBar(title: const Text('\u0645\u0630\u0643\u0631\u0627\u062A\u064A',style: TextStyle(color: Colors.white)), backgroundColor: Colors.transparent, elevation: 0),
    body: Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: TextField(controller: _c, maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(hintText:'...', hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          filled: true, fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          suffixIcon: IconButton(icon: const Icon(Icons.send, color: Color(0xFF6C63FF)), onPressed: _sv)))),
      Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal:16),
        itemCount: _es.length,
        itemBuilder: (_,i) => Card(color: Colors.white.withOpacity(0.05), margin: const EdgeInsets.only(bottom:8),
          child: ListTile(title: Text(_es[i]['x'], style: const TextStyle(color: Colors.white, fontSize:14)),
            subtitle: Text('${_es[i]['d'].hour}:${_es[i]['d'].minute}', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize:12))))))
    ]));
}