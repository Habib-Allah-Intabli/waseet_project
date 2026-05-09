import 'package:flutter/material.dart';

class TripDetailsDriverProfile extends StatelessWidget {
  final String driverName;

  const TripDetailsDriverProfile({super.key, required this.driverName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        _buildDriverInfo(),
        _buildCallButton(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCPGVlShcZMQ1MsqWnvjcTbPXzettU-O6APkTM0yaD1Yu00YPZyS4Ha8yfN2g0Wfubauh9I8nLAMxReMOHoT-gfJ9m_oOO2srVFQ2YQ8pA2bsDnsEYmZAqTsVJ8mIkJMb5EMVcp_capxw82Fjsp_kavXyxyaoZx4hEcSSZx-CApk28pwhTVCvjvfSVXX3oYef4crinfRyVfMKL754Og3OiL7UmllVWcre5I1AFF_tsMxQW8lbKNnWFfb-6rhsvjA2Hk71CQS5fNdl4',
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF000666),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            driverName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text('4.9/5', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('|', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 8),
              Text(
                '120 رحلة مكتملة',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDFE0FF),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.call, color: Color(0xFF000666)),
        onPressed: () {},
      ),
    );
  }
}
