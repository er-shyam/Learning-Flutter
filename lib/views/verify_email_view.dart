import 'package:flutter/material.dart';
import 'package:flutter_notes/constants/routes.dart';
import 'package:flutter_notes/services/auth/auth.service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 222, 215),
      appBar: AppBar(
        title: Text("Verify YOur Email"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Text(
            "We've sent you an email verification. Please open it to verify your account.",
          ),
          const Text(
            "If you haven't received a verification email yet, press the button below.",
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text("Send Email Verification"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(
                // ignore: use_build_context_synchronously
                context,
              ).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }
}
