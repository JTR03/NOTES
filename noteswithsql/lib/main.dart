import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteswithsql/constants/routes.dart';
import 'package:noteswithsql/firebase_options.dart';
import 'package:noteswithsql/views/login_view.dart';
import 'package:noteswithsql/views/notes_view.dart';
import 'package:noteswithsql/views/register_view.dart';
import 'package:noteswithsql/views/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute:(context) => const RegisterView(),
      verifyEmailRoute:(context) => const VerifyEmailView(),
      notesRoute:(context) => const NotesView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Text('Loading...');
        }
      },
    );
  }
}
