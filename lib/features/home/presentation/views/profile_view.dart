import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/views/edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final String? userId;
  final String? userName;

  const ProfileView({super.key, this.userId, this.userName});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthBloc>().state.user;
    final colorScheme = Theme.of(context).colorScheme;
    
    final displayUserName = userName ?? (userId == null ? currentUser?.fullName : 'مستخدم');
    final isOwnProfile = userId == null || userId == currentUser?.uId;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isOwnProfile && currentUser != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileView(user: currentUser),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBKKiFJPTqOJzbH8mvuGVLXWHT3ve6QxExU_ERMzJzA8jeb9Xi1-k6oj4lTOl2OsEzgS_GGc01A_HYzqIPkWESjwoTifANCR4ZEtIHw1UEtCpGW_gEnMW8ZwOAwU6ZlhWFUlLo7_5A9qtbSvaM3CRtL06ibvq1pzCF5cWs2W1jVW6Pd21UZCHLJ9LbPCMPaYxepv8QA_q22r_MnToCpkOITQi_EVRjGK-JWwIB5IRXiZlM0B4DhHSYB7jUk581_pFWMMniK4-itiUY',
                  ),
                ),
                Positioned(
                  bottom: -10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'موثوق',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            displayUserName ?? 'أحمد المنصور',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'عضو موثوق - وسيط',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatCard('124', 'عدد الرحلات', colorScheme),
              _StatCard('4.9', 'التقييم', colorScheme, isPrimary: true),
              _StatCard('89', 'التقييمات', colorScheme),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final ColorScheme scheme;
  final bool isPrimary;
  const _StatCard(
    this.value,
    this.label,
    this.scheme, {
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrimary ? scheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.white : scheme.primary,
                ),
              ),
              if (isPrimary)
                const Icon(Icons.star, color: Colors.white, size: 18),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isPrimary ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
