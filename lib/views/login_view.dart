import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              // Attempt to sign in with email and password
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                }
                // Ensure the widget is still mounted before navigating
                // if (!mounted) return;
              } on FirebaseAuthException catch (e) {
                // Handling FirebaseAuth exceptions
                String errorMessage;

                switch (e.code) {
                  case 'invalid-credential':
                    errorMessage = 'Invalid Credentials';
                    break;
                  case 'wrong-password': // Corrected error code
                    errorMessage = 'Wrong password';
                    break;
                  case 'user-not-found': // Additional common error case
                    errorMessage = 'User not found';
                    break;
                  default:
                    errorMessage =
                        'Error: ${e.message}'; // More descriptive error message
                }

                // Check if context is mounted before showing a dialog
                if (mounted) {
                  await showErrorDialog(context, errorMessage);
                }
              } catch (e) {
                // Handling any other exceptions
                if (mounted) {
                  await showErrorDialog(
                      context, 'An unexpected error occurred: ${e.toString()}');
                }
              }
            },
            child: const Text('Log in'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
