import 'package:flutter/material.dart';

class OptionsSectionWidget extends StatelessWidget {
  final bool allowParcel;
  final ValueChanged<bool> onAllowParcelChanged;
  final TextEditingController notesController;
  final TextEditingController priceController;

  const OptionsSectionWidget({
    super.key,
    required this.allowParcel,
    required this.onAllowParcelChanged,
    required this.notesController,
    required this.priceController,
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
              Icon(Icons.settings_input_component, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'خيارات إضافية',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'سعر المقعد (ل.س)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'مطلوب' : null,
            decoration: InputDecoration(
              hintText: 'مثال: 25000',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              prefixIcon: Icon(Icons.attach_money, color: colorScheme.primary),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.tertiary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'قبول الطرود؟',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'توصيل الأمانات',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Switch(
                  value: allowParcel,
                  onChanged: onAllowParcelChanged,
                  activeThumbColor: colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ملاحظات إضافية',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'تحدث عن سيارتك، نقطة اللقاء...',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
