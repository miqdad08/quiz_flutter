
import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class AtelierAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AtelierAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.background,
      leadingWidth: 56,
      title: const Text(
        'The Digital Atelier',
        style: TextStyle(
          color: AppTheme.teal,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AvatarBadge(),
        ),
      ],
    );
  }
}


class AvatarBadge extends StatelessWidget {
  const AvatarBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.tealLight,
          child: const Icon(Icons.person, color: AppTheme.teal, size: 28),
        ),
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.background, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}