import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/services/auth/auth_provider.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_event.dart';
import 'package:my_flutter_app/services/auth/bloc/auth_state.dart';

class AUthBloc extends Bloc<AuthEvent, AuthState> {
  AUthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
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
        final email = event.email;
        final password = event.password;
        try {
          final user = await provider.logIn(email: email, password: password);
          emit(AuthStateLoggedIn(user));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );

    //log out
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logOut();
          emit(const AuthStateLoggedOut(null));
        } on Exception catch (e) {
          emit(AuthStateLogOutFailure(e));
        }
      },
    );
  }
}
