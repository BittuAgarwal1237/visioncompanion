import 'package:equatable/equatable.dart';
import 'package:visioncompanion/features/auth/cubit/auth_user.dart';

enum AuthIssue {
  invalidCredentials,
  invalidEmail,
  emailInUse,
  weakPassword,
  network,
  tooManyAttempts,
  unknown,
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final AuthUser user;

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  const AuthError(this.issue);

  final AuthIssue issue;

  @override
  List<Object?> get props => [issue];
}
