import 'package:flutter/material.dart';

class TabButtonWidget extends StatelessWidget {
  final String text;
  final bool isSelected;

  const TabButtonWidget({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      // child: Text(
      // text,
      // style: TextStyle(
      //   color: isSelected ? Colors.white : Colors.grey[600],
      //   fontWeight: FontWeight.bold,
      // ),
      // ),
    );
  }
}
