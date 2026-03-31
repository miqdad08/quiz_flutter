import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_flutter/config/app_theme.dart';

class BmiResult {
  const BmiResult({
    required this.bmi,
    required this.category,
    required this.description,
    required this.range,
    required this.color,
    required this.icon,
  });

  final double   bmi;
  final String   category;
  final String   description;
  final String   range;
  final Color    color;
  final IconData icon;

  static BmiResult calculate(double heightCm, double weightKg) {
    final bmi = weightKg / pow(heightCm / 100, 2);

    if (bmi < 18.5) {
      return BmiResult(
        bmi: bmi, category: 'Underweight', range: '< 18.5',
        color: AppTheme.statusUnderweight, icon: Icons.arrow_downward_rounded,
        description: 'Your BMI is below the healthy range. Consider consulting '
            'a nutritionist to build a balanced, nourishing routine.',
      );
    } else if (bmi < 25) {
      return BmiResult(
        bmi: bmi, category: 'Normal Range', range: '18.5 – 24.9',
        color: AppTheme.statusNormal, icon: Icons.check_circle_rounded,
        description: 'Your BMI indicates a healthy balance. Maintaining this '
            'atelier-level precision requires consistent movement and mindful consumption.',
      );
    } else if (bmi < 30) {
      return BmiResult(
        bmi: bmi, category: 'Overweight', range: '25.0 – 29.9',
        color: AppTheme.statusOverweight, icon: Icons.warning_amber_rounded,
        description: 'Your BMI is slightly above the healthy range. Small, '
            'consistent lifestyle adjustments can recalibrate your balance.',
      );
    } else {
      return BmiResult(
        bmi: bmi, category: 'Obese', range: '≥ 30.0',
        color: AppTheme.statusObese, icon: Icons.error_outline_rounded,
        description: 'Your BMI is in the obese range. A structured plan with '
            'medical guidance can help you reset toward a healthier equilibrium.',
      );
    }
  }
}