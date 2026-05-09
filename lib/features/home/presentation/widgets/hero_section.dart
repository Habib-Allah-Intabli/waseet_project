import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';
// import 'search_field_widget.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final fullName = state.user?.fullName ?? 'مستخدم';
            final firstName = fullName.trim().split(' ').first;
            return Text(
              'أهلاً بك يا $firstName',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w900,
                fontSize: 32,
                color: colorScheme.primary,
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        // Container(
        //   padding: const EdgeInsets.all(24),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(24),
        //     boxShadow: [
        //       BoxShadow(
        //         color: colorScheme.primary.withValues(alpha: 0.05),
        //         blurRadius: 48,
        //         offset: const Offset(0, 24),
        //       ),
        //     ],
        //   ),
        //   child: Column(
        //     children: [
        //       Row(
        //         children: [
        //           Expanded(
        //             child: SearchFieldWidget(
        //               label: 'من',
        //               hint: 'مدينة الانطلاق',
        //               icon: Icons.my_location,
        //             ),
        //           ),
        //           const SizedBox(width: 16),
        //           Expanded(
        //             child: SearchFieldWidget(
        //               label: 'إلى',
        //               hint: 'وجهة السفر',
        //               icon: Icons.location_on,
        //             ),
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 24),
        //       ElevatedButton(
        //         onPressed: () {},
        //         style: ElevatedButton.styleFrom(
        //           padding: const EdgeInsets.symmetric(vertical: 16),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(16),
        //           ),
        //         ),
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(Icons.search),
        //             SizedBox(width: 8),
        //             Text('بحث عن رحلة'),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
