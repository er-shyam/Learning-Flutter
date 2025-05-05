import 'package:flutter/material.dart';
//import 'dart:developer' as devtools show log;
import 'package:flutter_notes/constants/routes.dart';
import 'package:flutter_notes/services/auth/auth.service.dart';
import 'package:flutter_notes/services/auth/auth_exceptions.dart';
import 'package:flutter_notes/utilities/show_error.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 214, 222, 215),
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  //user's email is verified
                  Navigator.of(
                    // ignore: use_build_context_synchronously
                    context,
                  ).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  //user's email is not verified
                  Navigator.of(
                    // ignore: use_build_context_synchronously
                    context,
                  ).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                }
              } on UserNotFoundAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "User not find");
              } on WrongPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "Wrong password provided");
              } on GenericAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "Authentication Error");
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text("Login"),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: Text("Not a user? Register here"),
          ),
        ],
      ),
    );
  }
}
