import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/core/utils/app_validator.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_button.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ ما')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('إنشاء حساب'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'أهلاً بك في وسيط',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text('انضم إلى شبكة النقل الأكبر بين المدن السورية'),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AuthTextField(
                                controller: _firstNameController,
                                label: 'الاسم الأول',
                                hint: 'أحمد',
                                prefixIcon: Icons.person_outline,
                                validator: (value) =>
                                    AppValidator.validateName(value, 'الاسم الأول'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AuthTextField(
                                controller: _lastNameController,
                                label: 'الاسم الأخير',
                                hint: 'منصور',
                                prefixIcon: Icons.person_outline,
                                validator: (value) =>
                                    AppValidator.validateName(value, 'الاسم الأخير'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        AuthTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hint: 'example@mail.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: AppValidator.validateEmail,
                        ),
                        const SizedBox(height: 15),
                        AuthTextField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
                          hint: '09XX XXX XXX',
                          prefixIcon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                          validator: AppValidator.validatePhone,
                        ),
                        const SizedBox(height: 15),
                        AuthTextField(
                          controller: _passwordController,
                          label: 'كلمة المرور',
                          hint: '********',
                          isPassword: true,
                          validator: AppValidator.validatePassword,
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state.status == AuthStatus.loading) {
                              return const CircularProgressIndicator();
                            }
                            return AuthButton(
                              text: 'إنشاء حساب جديد',
                              icon: Icons.person_add_alt_1,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        SignupRequested(
                                          user: UserEntity(
                                            uId: '',
                                            fullName:
                                                '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}',
                                            email: _emailController.text.trim(),
                                            phone: _phoneController.text.trim(),
                                            password: _passwordController.text,
                                          ),
                                        ),
                                      );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('سجل الدخول'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
