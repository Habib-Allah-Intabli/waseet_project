import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/core/constants/syrian_governorates.dart';

class CityFieldWidget extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;

  const CityFieldWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.controller,
  });

  @override
  State<CityFieldWidget> createState() => _CityFieldWidgetState();
}

class _CityFieldWidgetState extends State<CityFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final governorates = context.locale.languageCode == 'ar'
        ? SyrianGovernorates.arabic
        : SyrianGovernorates.english;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: Text(
                      'select_city'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: widget.controller.text.isEmpty
                        ? null
                        : widget.controller.text,
                    items: governorates.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(
                          city,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.controller.text = newValue ?? '';
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
