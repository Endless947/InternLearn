import 'package:flutter/material.dart';
import 'package:interactive_learn/pages/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo.png",
                height: 80,
                width: 150,
                fit: BoxFit.cover,
              ),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
