import 'package:flutter/material.dart';

class HomeSliverAppBar extends StatelessWidget {
  const HomeSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverAppBar(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
      pinned: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'وسيط',
            style: TextStyle(
              color: colorScheme.primary,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w900,
              fontSize: 24,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.search, color: colorScheme.primary),
                onPressed: () {
                  Navigator.pushNamed(context, '/search-trips');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
