import 'dart:async';
import '../models/user.dart';

class AuthService {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<bool> signIn(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication
    if (email == 'user@example.com' && password == 'password') {
      _currentUser = User(
        id: '1',
        name: 'John Doe',
        email: email,
        isDriver: false,
      );
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = null;
  }
}

final authService = AuthService();
