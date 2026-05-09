import 'package:flutter/material.dart';

class TripDetailsReviews extends StatelessWidget {
  const TripDetailsReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'تقييمات المسافرين',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                  color: Color(0xFF000666),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildReviewItem(
          name: 'ليلى حسن',
          rating: '5.0',
          comment: 'سائق محترم جداً، والسيارة نظيفة ومريحة. أنصح بالتعامل معه.',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuABoDOkUi9yIbX85JwgujPUk-bSjvtE0GmmdNmR6QZhJSKbd1RsTuGYdV2Itskj-jYE-LQDQe4rGzRLilqqeUKpxZS-_NGRcOpTi9SnaSaIsgUcRPyXeeIxxX-w9gsHbuDuyVcH5gcqQOdVvIprheIDOjy8wFGLNbMNsIk5Ziw0hvmCD9iREvhQMKIf4w2ZbMelac_4TGFBAzlyEVFw4Ca3FA1B6JfPRykLShWAOCk-c0zp6E0AhorTsQRvgvf-HmFB9fEySqTSXBg',
        ),
        _buildReviewItem(
          name: 'سامر علي',
          rating: '4.8',
          comment: 'وصلنا في الوقت المحدد تماماً، القيادة كانت هادئة وآمنة.',
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAr7_ln64wkplek3AprCbf5fO_jRgA9zvKgkFdsvtRiUKEdVQw132inJaGxNkLDgdQvIa_uAA_hoyHsQf0v64wwKNtUrC-y7UZG56gzhbks-8jhFR4d0X-VN9GV8IzzHGsLXR7B6-Au61xrW0-_6T-IEv29dhjIvXvI2DMmISIng3KEaOFxkAkAprZAYfo307qXYFUJi9C0w7OUF--FwVpaKh7yysoY62BMZ5MSolA-G6Xh0svqtS8GUVNmht2vhqcI7qcloxGNTJQ',
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String rating,
    required String comment,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
