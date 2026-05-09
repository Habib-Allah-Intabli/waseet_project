import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:waseet_project/features/auth/presentation/widgets/wasset_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // ننتظر لمدة ثانيتين لعرض الشعار قبل البدء في التحقق من حالة المستخدم
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthBloc>().add(AppStarted());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.onboarding) {
          Navigator.pushReplacementNamed(context, '/onboarding');
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WaseetLogo(),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
