import 'package:flutter/material.dart';

import '../config/app_theme.dart';

class ProfilePhotoCard extends StatelessWidget {
  final String imageUrl;

  const ProfilePhotoCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Photo placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 180,
              height: 200,
              color: const Color(0xFFB0C4C4),
              child:  Container(
                color: Color(0xFF7A9A9A),
                child: Image.network(
                  height: 80,
                  width: 80,
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Verified badge
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.teal,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.teal.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
