import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// مراحل التنفس 4-7-8:
/// 1. شهيق (4 ثوان)  🔵
/// 2. احتباس (7 ثوان) 🟣
/// 3. زفير (8 ثوان)  🟠
/// 4. انتظار (0 ثوان) قبل الدورة التالية
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});
  @override State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Color?> _colorAnim;

  bool _isRunning = false;
  int _cycles = 0;
  int _phase = 0; // 0=inhale, 1=hold, 2=exhale
  int _remaining = 0;
  Timer? _timer;

  static const _phaseDurations = [4, 7, 8];
  static const _phaseLabels = ['شهيق', 'احتباس', 'زفير'];
  static const _phaseColors = [
    Color(0xFF4A90D9), // أزرق — شهيق
    Color(0xFF9B59B6), // بنفسجي — احتباس
    Color(0xFFE67E22), // برتقالي — زفير
  ];
  static const _phaseEmojis = ['🫁', '🧘', '🌬️'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnim = ColorTween(
      begin: _phaseColors[0],
      end: _phaseColors[0],
    ).animate(_controller);
    _resetPhase();
  }

  void _resetPhase() {
    setState(() => _remaining = _phaseDurations[_phase]);
  }

  void _startSession() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isRunning = true;
      _cycles = 0;
      _phase = 0;
      _remaining = _phaseDurations[0];
    });
    _controller.duration = Duration(seconds: _phaseDurations[0]);
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _tick(Timer t) {
    setState(() => _remaining--);
    if (_remaining <= 0) _nextPhase();
  }

  void _nextPhase() {
    setState(() {
      if (_phase == 2) {
        // زفير انتهى → دورة جديدة
        _phase = 0;
        _cycles++;
      } else {
        _phase++;
      }
      _remaining = _phaseDurations[_phase];
    });

    _controller.reset();
    _controller.duration = Duration(seconds: _phaseDurations[_phase]);
    _controller.forward();

    HapticFeedback.lightImpact();
  }

  void _stopSession() {
    HapticFeedback.heavyImpact();
    _timer?.cancel();
    _controller.reset();
    setState(() {
      _isRunning = false;
      _phase = 0;
      _remaining = _phaseDurations[0];
      _cycles = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text('تمارين التنفس', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // العداد — الدورات
            if (_isRunning)
              Text(
                'الدورة $_cycles',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
              ),
            const SizedBox(height: 16),

            // الدائرة الرئيسية
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final phaseColor = _phaseColors[_phase];
                final scale = (_phase == 0)
                    ? _controller.value * 0.6 + 0.4 // شهيق: 0.4 ← 1.0
                    : (_phase == 1)
                        ? 1.0 // احتباس: ثابت
                        : 1.0 - (_controller.value * 0.6); // زفير: 1.0 ← 0.4
                return Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        phaseColor.withOpacity(0.6),
                        phaseColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: phaseColor.withOpacity(0.2),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Transform.scale(
                    scale: max(0.3, scale),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: phaseColor.withOpacity(0.2),
                        border: Border.all(
                          color: phaseColor.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _phaseEmojis[_phase],
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$_remaining',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: phaseColor,
                              ),
                            ),
                            Text(
                              _phaseLabels[_phase],
                              style: TextStyle(
                                fontSize: 16,
                                color: phaseColor.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 48),

            // مؤشر المراحل
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final active = i == _phase;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? _phaseColors[i].withOpacity(0.3)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: active ? _phaseColors[i].withOpacity(0.5) : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    '${_phaseEmojis[i]} ${_phaseLabels[i]}',
                    style: TextStyle(
                      color: active ? _phaseColors[i] : Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 48),

            // زر البدء/الإيقاف
            SizedBox(
              width: 200,
              height: 56,
              child: ElevatedButton(
                onPressed: _isRunning ? _stopSession : _startSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isRunning ? Colors.red.withOpacity(0.2) : const Color(0xFF6C63FF),
                  foregroundColor:
                      _isRunning ? Colors.red : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: BorderSide(
                      color: _isRunning
                          ? Colors.red.withOpacity(0.3)
                          : const Color(0xFF6C63FF).withOpacity(0.5),
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isRunning ? 'إيقاف' : 'ابدأ الجلسة',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // تعليمات
            if (!_isRunning)
              Text(
                'تقنية 4-7-8: شهيق 4ث ← احتباس 7ث ← زفير 8ث',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
