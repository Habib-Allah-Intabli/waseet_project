import 'package:flutter/material.dart';

class TripDetailsNotes extends StatelessWidget {
  final String notes;

  const TripDetailsNotes({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ملاحظات الرحلة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              right: BorderSide(color: colorScheme.primary, width: 4),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10),
            ],
          ),
          child: Text(
            notes.isEmpty ? 'لا توجد ملاحظات إضافية لهذه الرحلة.' : notes,
            style: const TextStyle(color: Colors.black87, height: 1.5),
          ),
        ),
      ],
    );
  }
}
