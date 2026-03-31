import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../widgets/profile_bio.dart';
import '../widgets/profile_photo_card.dart';
import 'main_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfilePhotoCard(
            imageUrl:
                "https://media.licdn.com/dms/image/v2/D5603AQE9tWJYj0fzeA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1669633270202?e=1776297600&v=beta&t=wbV13ejXyrsnKha3GfiwQuO3W-r-zl38zt8gMX4QyHI",
          ),
          const SizedBox(height: 24),
          const RoleChip(label: 'Mobile Developer'),
          const SizedBox(height: 12),
          const ProfileName(name: 'Ahmad Miqdad'),
          const SizedBox(height: 16),
          const ProfileBio(
            text:
                'I am a student of Information Technology at CCIT,'
                'Faculty of Engineering, Universitas Indonesia. I am'
                '          interested in Android programming and have some'
                'knowledge of Flutter. I have over two years of'
                'experience learning Mobile Development (Flutter) and'
                'am currently focused on Fullstack development. I am'
                'looking for opportunities in this area and hope to use'
                'my programming skills to meet Industry 4.0 standards.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}


class ProfileName extends StatelessWidget {
  const ProfileName({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppTheme.textPrimary,
        height: 1.1,
        letterSpacing: -1,
      ),
    );
  }
}

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.tealLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.teal,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
