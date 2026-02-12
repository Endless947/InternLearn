import 'package:flutter/material.dart';
import 'package:interactive_learn/pages/tabs/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Text('Login Form', style: Theme.of(context).textTheme.headlineMedium!),
        TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Login'),
        ),

        Column(
          children: [
            Text("Or Sign Up With"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // spacing: ,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
                IconButton(onPressed: () {}, icon: Icon(Icons.g_mobiledata)),
                IconButton(onPressed: () {}, icon: Icon(Icons.apple)),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Don\'t have an account?'),
            GestureDetector(
              onTap: () {},
              child: Text("Sign Up", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ],
    );
  }
}
