import 'package:flutter/material.dart';

class WaseetLogo extends StatelessWidget {
  const WaseetLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1D70),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.local_shipping,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Waseet',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'تصلك أينما كنت في أرجاء سوريا',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
