import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cek User yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream perubahan status auth (Login/Logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Register
  Future<void> register({required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}