import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/services/auth/auth_provider.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_state.dart';

class AUthBloc extends Bloc<AuthEvent, AuthState> {
  AUthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    // register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AUthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegisteratering(e));
      }
    });
// initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else {
        if (!user.isEmailVerified) {
          emit(const AUthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      }
    });

    // log in
    on<AUthEventLogIn>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ));
        // await Future.delayed(const Duration(seconds: 3));
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(const AUthStateNeedsVerification());
          } else {
            emit(
              const AuthStateLoggedOut(exception: null, isLoading: false),
            );
            emit(AuthStateLoggedIn(user));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    //log out
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(
            const AuthStateLoggedOut(exception: null, isLoading: false),
          );
        } on Exception catch (e) {
          emit(
            AuthStateLoggedOut(exception: e, isLoading: false),
          );
        }
      },
    );
  }
}
