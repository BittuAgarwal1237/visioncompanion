import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  factory AuthUser.fromFirebase(User user) {
    final email = user.email ?? '';
    final given = user.displayName?.trim() ?? '';
    final fallback = email.contains('@') ? email.split('@').first : email;

    return AuthUser(
      uid: user.uid,
      name: given.isNotEmpty ? given : fallback,
      email: email,
      photoUrl: user.photoURL,
    );
  }

  String get initial => name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

  @override
  List<Object?> get props => [uid, name, email, photoUrl];
}
