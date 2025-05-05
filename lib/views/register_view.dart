import 'package:flutter/material.dart';
import 'package:flutter_notes/constants/routes.dart';
import 'package:flutter_notes/services/auth/auth.service.dart';
import 'package:flutter_notes/services/auth/auth_exceptions.dart';
import 'package:flutter_notes/utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "Weak password");
              } on EmailAlreadyInUseAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "Email is already in use");
              } on InvalidEmailAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "This is not a valid email");
              } on GenericAuthException {
                // ignore: use_build_context_synchronously
                await showErrorDialog(context, "Failed to Register");
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (context) => false);
            },
            child: const Text("Already a user? Login here"),
          ),
        ],
      ),
    );
  }
}
