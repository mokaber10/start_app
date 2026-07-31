import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _c = TextEditingController();
  List<Map<String, dynamic>> _entries = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('journal_entries');
    if (saved != null) {
      final decoded = jsonDecode(saved) as List;
      setState(() {
        _entries = decoded.cast<Map<String, dynamic>>();
        _loaded = true;
      });
    } else {
      setState(() => _loaded = true);
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journal_entries', jsonEncode(_entries));
  }

  void _addEntry() {
    if (_c.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    final now = DateTime.now();
    setState(() {
      _entries.insert(0, {
        'text': _c.text.trim(),
        'date': now.toIso8601String().substring(0, 10),
        'time': '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      });
      _c.clear();
    });
    _save();
  }

  void _deleteEntry(int index) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('حذف المذكرة', style: TextStyle(color: Colors.white)),
        content: const Text('هل أنت متأكد؟', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _entries.removeAt(index));
              _save();
              Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    if (date == today) return 'اليوم';
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
    if (date == yesterday) return 'أمس';
    return date;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text('مذكراتي', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Input area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _c,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'اكتب مشاعرك...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF6C63FF),
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: _addEntry,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ),

          // Entries list
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('📝', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          'لا مذكرات بعد',
                          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _entries.length,
                    itemBuilder: (_, i) {
                      final e = _entries[i];
                      return Dismissible(
                        key: Key('j_$i'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        ),
                        onDismissed: (_) => _deleteEntry(i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['text'],
                                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    _formatDate(e['date']),
                                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    e['time'],
                                    style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 11),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => _deleteEntry(i),
                                    child: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.2), size: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
