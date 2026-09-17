import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

class AuthService with UiLoggy {
  final FirebaseAuth auth;

  const AuthService({required this.auth});

  Future<User?> _ensureAnonymousAuth() async {
    // Ensure persistence survives tab refreshes on Flutter Web
    if (kIsWeb) {
      await auth.setPersistence(Persistence.LOCAL);
    }
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      loggy.debug('Authenticating as  anon user');
      final credential = await auth.signInAnonymously();
      currentUser = credential.user;
    }
    loggy.debug('Authenticated anonymously with ${currentUser!.uid}');
    return currentUser;
  }

  Future<String?> getIdToken() async {
    final user = await _ensureAnonymousAuth();
    return await user?.getIdToken();
  }
}

@riverpod
FirebaseAuth firebaseAuth(_) => FirebaseAuth.instance;

@riverpod
AuthService authService(Ref ref) =>
    AuthService(auth: ref.watch(firebaseAuthProvider));
