import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/constants/routes.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_state.dart';
import 'package:my_flutter_app/services/auth/firebase_auth_provider.dart';
import 'package:my_flutter_app/views/login_view.dart';
import 'package:my_flutter_app/views/notes/create_update_note_view.dart';
import 'package:my_flutter_app/views/notes/notes_view.dart';
import 'package:my_flutter_app/views/register_view.dart';
import 'package:my_flutter_app/views/verify_email_view.dart';

void main() {
  // Used for native code to interact with the Flutter engine ie. Java/Kotlin for android and swift/obj-c for ios
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AUthBloc>(
        create: (context) => AUthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

// ************* Future call should not be inside futureBuilder ??
  @override
  Widget build(BuildContext context) {
    context.read<AUthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AUthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AUthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
