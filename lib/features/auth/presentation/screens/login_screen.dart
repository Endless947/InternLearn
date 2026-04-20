import 'package:flutter/material.dart';
import 'package:interactive_learn/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Image.asset(
                'assets/images/logo.png',
                height: 90,
                width: 160,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
