import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_flutter/config/app_theme.dart';

import '../models/bmi_result.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  final _heightCtrl = TextEditingController(text: '175');
  final _weightCtrl = TextEditingController(text: '70');
  final _formKey = GlobalKey<FormState>();

  BmiResult? _result;
  bool _pressed = false;

  late final AnimationController _animCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _fadeAnim = CurvedAnimation(
    parent: _animCtrl,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _slideAnim = Tween<Offset>(
    begin: const Offset(0, 0.15),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

  @override
  void dispose() {
    _animCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final h = double.tryParse(_heightCtrl.text.trim()) ?? 0;
    final w = double.tryParse(_weightCtrl.text.trim()) ?? 0;
    setState(() => _result = BmiResult.calculate(h, w));
    _animCtrl
      ..reset()
      ..forward();
  }

  String? _validatePositive(String? v) {
    if (v == null || v.isEmpty) return 'This field is required';
    final n = double.tryParse(v);
    if (n == null || n <= 0) return 'Enter a valid positive number';
    return null;
  }

  // Reused twice with different params — helper method, not a separate class
  Widget _inputCard({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String fieldLabel,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.teal,
                ),
              ),
              const Spacer(),
              Icon(icon, size: 20, color: AppTheme.teal),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fieldLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: _validatePositive,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
              filled: true,
              fillColor: AppTheme.inputBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.teal, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.statusObese,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppTheme.statusObese,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            const Text(
              'Health\nAtelier.',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                height: 1.05,
                color: AppTheme.textPrimary,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.accentBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Refine your physical equilibrium through architectural precision. '
                      'Use our tailored diagnostic tools to monitor your progress.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.65,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Input cards ───────────────────────────────────────────────────
            _inputCard(
              label: 'DIMENSIONS',
              icon: Icons.straighten_rounded,
              controller: _heightCtrl,
              fieldLabel: 'Height (cm)',
              hint: '175',
            ),
            const SizedBox(height: 16),
            _inputCard(
              label: 'MASS',
              icon: Icons.monitor_weight_outlined,
              controller: _weightCtrl,
              fieldLabel: 'Weight (kg)',
              hint: '70',
            ),
            const SizedBox(height: 28),

            // ── Calculate button ──────────────────────────────────────────────
            GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) {
                setState(() => _pressed = false);
                _calculate();
              },
              onTapCancel: () => setState(() => _pressed = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                transform: Matrix4.identity()..scale(_pressed ? 0.97 : 1.0),
                height: 58,
                decoration: BoxDecoration(
                  color: _pressed ? AppTheme.tealDark : AppTheme.teal,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.teal.withOpacity(_pressed ? 0.2 : 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calculate_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Calculate Result',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Result (animated in) ──────────────────────────────────────────
            if (_result != null)
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: _ResultCard(result: _result!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Result Card ──────────────────────────────────────────────────────────────
// Kept as its own class: data-driven, non-trivial layout, logically distinct.
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final BmiResult result;

  // Tiny chip — too simple for a class, lives as a local helper
  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: AppTheme.inputBg,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppTheme.textSecondary,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDE8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BMI value + gauge ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT INDEX',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppTheme.teal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            result.bmi.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                              height: 1.0,
                              letterSpacing: -2,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10, left: 4),
                            child: Text(
                              'kg/m²',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  size: const Size(72, 72),
                  painter: _GaugePainter(bmi: result.bmi, color: result.color),
                ),
              ],
            ),
          ),

          // ── Status strip ────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: result.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: result.color, width: 3)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: result.color,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      result.category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(result.icon, color: result.color, size: 28),
              ],
            ),
          ),

          // ── Description ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text(
              result.description,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.65,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // ── Chips ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Wrap(
              spacing: 10,
              children: [
                _chip('Target: ${result.range}'),
                _chip(
                  result.bmi >= 18.5 && result.bmi < 25
                      ? 'Last Check: 2 Days'
                      : 'Consult a Doctor',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gauge Painter ────────────────────────────────────────────────────────────
class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.bmi, required this.color});

  final double bmi;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 8;
    final arc = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    canvas.drawArc(
      arc,
      pi * 0.75,
      pi * 1.5,
      false,
      Paint()
        ..color = AppTheme.inputBg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final pct = ((bmi - 10) / 30).clamp(0.0, 1.0);
    canvas.drawArc(
      arc,
      pi * 0.75,
      pi * 1.5 * pct,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: 'BMI',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.bmi != bmi || old.color != color;
}
