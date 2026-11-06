import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visioncompanion/features/auth/cubit/auth_state.dart';
import 'package:visioncompanion/features/auth/cubit/auth_user.dart';
import 'package:visioncompanion/features/auth/data/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthLoading()) {
    _subscription = _repo.authChanges.listen(_onUserChanged);
  }

  final AuthRepository _repo;
  late final StreamSubscription<User?> _subscription;

  void _onUserChanged(User? user) {
    if (user == null) {
      emit(const Unauthenticated());
    } else {
      emit(Authenticated(AuthUser.fromFirebase(user)));
    }
  }

  Future<void> signIn(String email, String password) {
    return _run(() => _repo.signInWithEmail(email, password));
  }

  Future<void> register(String name, String email, String password) {
    return _run(() async {
      await _repo.register(name, email, password);
      final user = _repo.currentUser;
      if (user != null) {
        emit(Authenticated(AuthUser.fromFirebase(user)));
      }
    });
  }

  Future<void> signInWithGoogle() => _run(_repo.signInWithGoogle);

  Future<void> signOut() => _repo.signOut();

  Future<void> _run(Future<void> Function() action) async {
    emit(const AuthLoading());
    try {
      await action();
    } on SignInCancelled {
      emit(const Unauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_issueFor(e.code)));
    } on PlatformException catch (e) {
      final offline = e.code == 'network_error';
      emit(AuthError(offline ? AuthIssue.network : AuthIssue.unknown));
    } catch (_) {
      emit(const AuthError(AuthIssue.unknown));
    }
  }

  AuthIssue _issueFor(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-login-credentials':
        return AuthIssue.invalidCredentials;
      case 'invalid-email':
        return AuthIssue.invalidEmail;
      case 'email-already-in-use':
        return AuthIssue.emailInUse;
      case 'weak-password':
        return AuthIssue.weakPassword;
      case 'network-request-failed':
        return AuthIssue.network;
      case 'too-many-requests':
        return AuthIssue.tooManyAttempts;
      default:
        return AuthIssue.unknown;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
