import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_bloc.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email-ID")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                "We've sent you an email verification. Kindly open it to verify your account "),
            const Text("Didn't receive email?"),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text("Re-Send email verification"),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text("Restart"),
            ),
          ],
        ),
      ),
    );
  }
}
