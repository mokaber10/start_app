import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({super.key});
  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  int _streak = 0;
  List<bool> _days = List.generate(30, (_) => false);
  bool _checkedToday = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('streak_data');
    final lastDate = prefs.getString('streak_last_date') ?? '';
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (saved != null) {
      final parts = saved.split(',').map((e) => e == '1').toList();
      setState(() {
        _days = List.generate(30, (i) => i < parts.length ? parts[i] : false);
        _streak = _calcStreak(_days);
        _checkedToday = lastDate == today;
      });
    }
  }

  Future<void> _checkIn() async {
    if (_checkedToday) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    setState(() {
      // Shift days and add new day at front
      _days.insert(0, true);
      if (_days.length > 30) _days = _days.sublist(0, 30);
      _streak = _calcStreak(_days);
      _checkedToday = true;
    });

    // Save
    await prefs.setString('streak_data', _days.map((d) => d ? '1' : '0').join(','));
    await prefs.setString('streak_last_date', today);
  }

  int _calcStreak(List<bool> days) {
    int count = 0;
    for (final d in days) {
      if (d) { count++; } else { break; }
    }
    return count;
  }

  String _streakTitle() {
    if (_streak == 0) return 'لم تبدأ بعد';
    if (_streak >= 60) return '👑 متقن';
    if (_streak >= 21) return '⭐ ملتزم';
    if (_streak >= 7) return '🔰 مبتدئ';
    return '🔥 $streak يوم متتالية';
  }

  String _streakSubtitle() {
    if (_streak == 0) return 'ابدأ رحلتك اليوم';
    if (_streak >= 60) return '${_streak} يوماً — أنت أسطورة!';
    if (_streak >= 21) return 'استمر، ${_streak} يوماً وأنت متقن';
    if (_streak >= 7) return '${_streak} يوماً — بداية قوية';
    return 'أحسنت! استمر ليوم غد';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text('استمراريتي', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Streak badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF4A0080)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$_streak',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _streakTitle(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              _streakSubtitle(),
              style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
            ),

            const SizedBox(height: 32),

            // أيام الشهر
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: _days.map((d) => Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: d ? const Color(0xFF6C63FF) : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: d
                        ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.5))
                        : null,
                  ),
                  child: Center(
                    child: d
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text('·', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 16)),
                  ),
                )).toList(),
              ),
            ),

            const SizedBox(height: 32),

            // زر تسجيل اليوم
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: _checkedToday ? null : _checkIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  disabledBackgroundColor: Colors.white.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: _checkedToday
                          ? const Color(0xFF6C63FF).withOpacity(0.3)
                          : const Color(0xFF6C63FF).withOpacity(0.5),
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _checkedToday ? 'تم التسجيل اليوم ✅' : 'سجّل يومي',
                  style: TextStyle(
                    color: _checkedToday ? Colors.white60 : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
