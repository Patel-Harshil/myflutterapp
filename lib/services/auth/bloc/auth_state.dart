import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:my_flutter_app/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegisteratering extends AuthState {
  final Exception? exception;

  const AuthStateRegisteratering(this.exception);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AUthStateNeedsVerification extends AuthState {
  const AUthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
  @override
  List<Object?> get props => [exception, isLoading];
}
