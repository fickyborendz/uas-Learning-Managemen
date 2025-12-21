import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as app_user;
import '../repositories/auth_repository.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  AuthStatus _status = AuthStatus.initial;
  app_user.User? _user;
  String _errorMessage = '';

  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _init();
  }

  AuthStatus get status => _status;
  app_user.User? get user => _user;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  void _init() {
    _authRepository.authStateChanges.listen((app_user.User? user) {
      _user = user;
      if (user != null) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('🔐 AuthProvider: Starting login process for $email');
      
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final app_user.User? user = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      if (user != null) {
        debugPrint('✅ AuthProvider: Login successful for ${user.email}');
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        debugPrint('❌ AuthProvider: Login failed - no user returned');
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Login gagal. Silakan coba lagi.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('🔥 AuthProvider: Login error: $e');
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final app_user.User? user = await _authRepository.signInWithGoogle();

      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Google login failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      await _authRepository.resetPassword(email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      if (_user == null) return false;

      _status = AuthStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final updatedUser = await _authRepository.updateProfile(
        userId: _user!.id,
        name: name,
        bio: bio,
        profilePhotoUrl: profilePhotoUrl,
      );

      _user = updatedUser;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _authRepository.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void reset() {
    _status = AuthStatus.initial;
    _user = null;
    _errorMessage = '';
    notifyListeners();
  }
}