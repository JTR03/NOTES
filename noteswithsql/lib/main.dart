
import 'package:flutter/material.dart';
import 'package:noteswithsql/constants/routes.dart';
import 'package:noteswithsql/services/auth/auth_service.dart';
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
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
