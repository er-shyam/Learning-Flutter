import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                final userCredential = FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == '') {
                  devtools.log('weak password');
                } else if (e.code == 'email-already-in-use') {
                  devtools.log("Email is already in use by shyam");
                } else if (e.code == 'invalid-email') {
                  devtools.log('Email is invalid');
                }
              }
            },
            child: Text("Register"),
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login/', (context) => false);
            },
            child: const Text("Already a user? Login here"),
          ),
        ],
      ),
    );
  }
}
