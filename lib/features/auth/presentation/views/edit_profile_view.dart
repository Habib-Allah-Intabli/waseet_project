import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/core/utils/app_validator.dart';
import 'package:waseet_project/features/auth/domain/entities/user.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_button.dart';
import 'package:waseet_project/features/auth/presentation/widgets/auth_text_field.dart';

class EditProfileView extends StatefulWidget {
  final UserEntity user;
  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && !state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
          );
          Navigator.pop(context);
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'فشل التحديث')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('edit_profile'.tr()),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  label: 'full_name'.tr(),
                  hint: 'أحمد منصور',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) => AppValidator.validateName(value, 'full_name'.tr()),
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'phone'.tr(),
                  hint: '09XX XXX XXX',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_android,
                  keyboardType: TextInputType.phone,
                  validator: AppValidator.validatePhone,
                ),
                const SizedBox(height: 32),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    return AuthButton(
                      text: 'save_changes'.tr(),
                      icon: Icons.save,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedUser = widget.user.copyWith(
                            fullName: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                          );
                          context.read<AuthBloc>().add(
                                UpdateProfileRequested(user: updatedUser),
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
      ),
    );
  }
}
