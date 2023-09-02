// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/services/auth/auth_exceptions.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_state.dart';
import 'package:my_flutter_app/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AUthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          await showErrorDialog(context, "Weak Password");
        } else if (state is EmailAlreadyInUseAuthException) {
          await showErrorDialog(context, "Email already exists");
        } else if (state is InvalidEmailAuthException) {
          await showErrorDialog(context, "Invalid email");
        } else if (state is GenericAuthException) {
          await showErrorDialog(context, "Failed to register");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register View"),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter email_ID',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context
                    .read<AUthBloc>()
                    .add(AuthEventRegister(email, password));
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AUthBloc>().add(const AuthEventLogOut());
              },
              child: const Text("Already registered? Login Here"),
            ),
          ], //children
        ),
      ),
    );
  } //build
}
