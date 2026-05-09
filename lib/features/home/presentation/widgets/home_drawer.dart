import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:waseet_project/core/theme/theme_bloc.dart';
import 'package:waseet_project/features/favorites/presentation/views/favorites_view.dart';
import 'package:waseet_project/features/home/presentation/views/settings_view.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    final colorScheme = Theme.of(context).colorScheme;
    final themeBloc = context.watch<ThemeBloc>();
    final isDark = themeBloc.state.themeMode == ThemeMode.dark;
    final isArabic = context.locale.languageCode == 'ar';

    return Drawer(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          left: isArabic ? const Radius.circular(32) : Radius.zero,
          right: isArabic ? Radius.zero : const Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(user, colorScheme),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrawerItem(
                  icon: Icons.favorite_outline,
                  title: 'favorites'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesView()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.language,
                  title: 'language'.tr(),
                  trailing: Text(
                    isArabic ? 'العربية' : 'English',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () => _showLanguageDialog(context),
                ),
                _buildDrawerItem(
                  icon: isDark ? Icons.light_mode : Icons.dark_mode,
                  title: isDark ? 'light_mode'.tr() : 'night_mode'.tr(),
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: colorScheme.primary,
                    onChanged: (_) => themeBloc.add(ToggleTheme()),
                  ),
                  onTap: () => themeBloc.add(ToggleTheme()),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'settings'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsView()),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(indent: 32, endIndent: 32),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildDrawerItem(
              icon: Icons.logout,
              title: 'logout'.tr(),
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('choose_language'.tr(), textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Cairo')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية', textAlign: TextAlign.right),
              leading: context.locale.languageCode == 'ar' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                context.setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English', textAlign: TextAlign.right),
              leading: context.locale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.green) : null,
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.grey[200],
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBW40R3eXp6sQHguSVUww6-ULpTJvUgsIvEClDxlAyyc87Igj7GuhS5t9A43qYAvQoaZmFfKYYpG2aby7WLzNPbUARl9_nD1nS6pkrFeflObHVWrvL-ACUKqYfkAteY8UmiRy50jwJjWsIkum_4VM059xzN1YAgBBgDRek0Mr8qEkabTkrbTqEXDrZZDpHsnPBrO7UipqtIGyew4k5E4yKf2bnaEIGUAU2UCdh2bORfVaO6IIbEuWMpTHeB5zOckHX0xkOAQ5RfjBw',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.fullName ?? 'مستخدم وسيط',
            style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
          ),
          Text(
            user?.phone ?? '',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final defaultColor = isDark ? Colors.white70 : Colors.black87;
        
        return ListTile(
          leading: Icon(icon, color: iconColor ?? defaultColor, size: 22),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor ?? defaultColor,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
      }
    );
  }
}
