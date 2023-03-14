import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteswithsql/constants/routes.dart';
import 'package:noteswithsql/firebase_options.dart';
import 'package:noteswithsql/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredentials =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(userCredentials);
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await showErrorDialog(
                    context,
                    'Email already in use',
                  );
                } else if (e.code == 'invalid-email') {
                  await showErrorDialog(
                    context,
                    'Invalid Email',
                  );
                } else {
                  await showErrorDialog(
                    context,
                    e.code,
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account? login here'))
        ],
      ),
    );
  }
}
