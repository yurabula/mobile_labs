import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/CustomTextField.dart';
import 'package:flutter_application_1/core/widgets/CustomButton.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:flutter_application_1/services/AuthService.dart';
import 'package:flutter_application_1/utils/ValidationUtils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() == true) {
      final authService = Provider.of<AuthService>(context, listen: false);

      final user = UserModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
      );

      final result = await authService.register(user);

      if (result && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2C4260),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB5DBFF), Color(0xFFE2F1FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4260),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'Full Name',
                              icon: Icons.person_outline_rounded,
                              validator: ValidationUtils.validateName,
                            ),
                            CustomTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              icon: Icons.email_outlined,
                              validator: ValidationUtils.validateEmail,
                            ),
                            CustomTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              icon: Icons.lock_outline_rounded,
                              obscureText: !_isPasswordVisible,
                              validator: ValidationUtils.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            CustomTextField(
                              controller: _phoneController,
                              labelText: 'Phone (Optional)',
                              icon: Icons.phone_outlined,
                              validator: ValidationUtils.validatePhone,
                            ),
                            const SizedBox(height: 32),
                            CustomButton(
                              text: 'Create Account',
                              isPrimary: true,
                              isLoading: authService.isLoading,
                              onPressed:
                                  authService.isLoading
                                      ? null
                                      : _handleRegister,
                            ),
                            if (authService.errorMessage != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                authService.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: const Color(0xFF2C4260).withOpacity(0.8),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF47BFDF),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
