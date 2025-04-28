import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'Enter your Email here'),
        ),
        TextField(
          controller: _passwordController,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Enter your Password here'),
        ),
        TextButton(
          onPressed: () async {
            final email = _emailController.text;
            final password = _passwordController.text;
            try {
              final userCredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(email: email, password: password);
              print(userCredential);
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('user not found');
              } else if (e.code == 'invalid-credential')
                print('wrong password');
            }
          },
          child: Text("Login"),
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
