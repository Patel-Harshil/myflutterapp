// Used for connecting the UI and Authentication Provider

import "package:my_flutter_app/services/auth/auth_provider.dart";
import "package:my_flutter_app/services/auth/auth_user.dart";
import "package:my_flutter_app/services/auth/firebase_auth_provider.dart";

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider); //Constructor

  //constructor => provider = FirebaseAuthProvider
  factory AuthService.firebase() => AuthService(
      FirebaseAuthProvider()); //FirebaseAuthProvider() is a default constructor for creating object of class FirebaseAuthProvider

  @override
  Future<void> initialize() async {
    return await provider.initialize();
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    return await provider.createUser(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    return await provider.logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() async {
    return await provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    return await provider.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    return await provider.sendPasswordReset(toEmail: toEmail);
  }
}
