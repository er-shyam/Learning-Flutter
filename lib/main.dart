import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(title: Text("Register")),
      body: FutureBuilder(
        future:Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: ( context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return
              Column(
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
                      final userCredential = FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print(userCredential);
                    },
                    child: Text("Register"),
                  ),
                ],
              );
            default :
              return const Text('Loading.....');
          }
        },
      ),
    );
  }
}
