import 'package:flutter/material.dart';

class SmartMatchBanner extends StatelessWidget {
  const SmartMatchBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB3JSLmWaiBEiSlCaNVb85y4txYe0mLzBBb7_kv8HRjJjrOWmm5WG50eTJxsfQjw-p_H0anl9VDQeF0rdtdySeHoCF3VlLmzDMUH6FVIDiQgXhdCwU5CnlzWSRl6bZdMPhZkhZD9VyYhAWTUut3sYaHyHft54aRqj7VBkAQSf3uDjI70mZEdJ3c0DGAP5UQNwIG0kyJEKQavf_mQxD746QlwIaRr8oprjgmldA0Wn1WiAP9A7oKwCHfzkpx3ObTaP9GLP9p_O3jxrg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [colorScheme.primary.withValues(alpha: 0.8), Colors.transparent],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'رحلات تناسبك',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'وجدنا 12 رحلة جديدة من دمشق\nإلى حلب اليوم',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.tertiary,
                foregroundColor: Colors.black,
                minimumSize: const Size(100, 36),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'عرض الآن',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
