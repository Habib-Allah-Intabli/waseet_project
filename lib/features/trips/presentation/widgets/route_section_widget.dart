import 'package:flutter/material.dart';
import 'city_field_widget.dart';

class RouteSectionWidget extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;

  const RouteSectionWidget({
    super.key,
    required this.fromController,
    required this.toController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.route, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'مسار الرحلة',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CityFieldWidget(
            label: 'من (مدينة الانطلاق)',
            icon: Icons.location_on,
            iconColor: colorScheme.primary,
            controller: fromController,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(height: 32, width: double.infinity),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    final temp = fromController.text;
                    fromController.text = toController.text;
                    toController.text = temp;
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
            ],
          ),
          CityFieldWidget(
            label: 'إلى (وجهة الرحلة)',
            icon: Icons.my_location,
            iconColor: colorScheme.secondary,
            controller: toController,
          ),
        ],
      ),
    );
  }
}
