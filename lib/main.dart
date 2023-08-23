import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants/routes.dart';
import 'package:my_flutter_app/services/auth/auth_exceptions.dart';
import 'package:my_flutter_app/services/auth/auth_service.dart';
import 'package:my_flutter_app/views/login_view.dart';
import 'package:my_flutter_app/views/notes/create_update_note_view.dart';
import 'package:my_flutter_app/views/notes/notes_view.dart';
import 'package:my_flutter_app/views/register_view.dart';
import 'package:my_flutter_app/views/verify_email_view.dart';

void main() {
  // Used for native code to interact with the Flutter engine ie. Java/Kotlin for android and swift/obj-c for ios
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

// ************* Future call should not be inside futureBuilder ??
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      // Used to create widgets based on latest snapshot of interaction with a Future (Future function call)
      future: AuthService.firebase().initialize(), //initialize firebase
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              try {
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
              } on UserNotFoundAuthException {
                return const LoginView();
              }
            default:
              return const CircularProgressIndicator();
          }
        }
      }, //Builder
    );
  }
}
