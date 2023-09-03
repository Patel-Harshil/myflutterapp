// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/services/auth/auth_exceptions.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_state.dart';
import 'package:my_flutter_app/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(
                  context, "Cannot find user with entered credentials!");
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(context, "Wrong credentials");
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, "Authentication error");
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Welcome back!"),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AUthEventLogIn(email, password),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text("I forgot my password"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventRegister(),
                      );
                },
                child: const Text("Not registered yet? Register here!"),
              ),
            ], //children
          ),
        ),
      ),
    );
  } //build
}
