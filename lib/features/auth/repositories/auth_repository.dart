import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart' as app_user;
import '../models/user_role.dart';

abstract class AuthRepository {
  Future<app_user.User?> signInWithEmailAndPassword(String email, String password);
  Future<app_user.User?> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<app_user.User> updateProfile({
    required String userId,
    String? name,
    String? bio,
    String? profilePhotoUrl,
  });
  Future<app_user.User?> getCurrentUser();
  Stream<app_user.User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<app_user.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      debugPrint('🚀 Firebase Auth: Attempting login for email: $email');
      
      // Check if Firebase is properly configured
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        debugPrint('⚠️ Firebase Auth: No current user, checking configuration...');
      }
      
      final firebase_auth.UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        debugPrint('✅ Firebase Auth: Login successful for user: ${result.user!.email}');
        return await _mapFirebaseUserToUser(result.user!);
      } else {
        debugPrint('❌ Firebase Auth: Login failed - no user returned');
        return null;
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('🔥 Firebase Auth Exception: ${e.code} - ${e.message}');
      
      // Check for configuration errors
      if (e.code == 'invalid-api-key' || e.message?.contains('apiKey') == true) {
        throw Exception('Konfigurasi Firebase salah. Pastikan firebase_options.dart sudah dikonfigurasi dengan benar.');
      }
      
      throw _handleAuthException(e);
    } on SocketException catch (e) {
      debugPrint('🌐 Network Error: $e');
      throw Exception('Network error: Please check your internet connection.');
    } catch (e) {
      debugPrint('💥 Unexpected Error: ${e.toString()}');
      
      // Check for common configuration issues
      if (e.toString().contains('apiKey') || e.toString().contains('Firebase')) {
        throw Exception('Konfigurasi Firebase belum benar. Silakan periksa firebase_options.dart dan pastikan semua placeholder sudah diganti dengan nilai real dari Firebase Console.');
      }
      
      throw Exception('Login gagal: ${e.toString()}');
    }
  }

  @override
  Future<app_user.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential result = await _firebaseAuth.signInWithCredential(credential);
      
      if (result.user != null) {
        return await _mapFirebaseUserToUser(result.user!, googleUser: googleUser);
      }
      return null;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Google login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<app_user.User> updateProfile({
    required String userId,
    String? name,
    String? bio,
    String? profilePhotoUrl,
  }) async {
    try {
      // In a real app, you would update this in your database
      // For now, we'll simulate the update
      final firebase_auth.User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Update Firebase Auth profile if needed
      if (name != null) {
        await currentUser.updateDisplayName(name);
      }

      // In a real implementation, you would update your database here
      // and return the updated user object
      return await _mapFirebaseUserToUser(currentUser);
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<app_user.User?> getCurrentUser() async {
    final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      return await _mapFirebaseUserToUser(firebaseUser);
    }
    return null;
  }

  @override
  Stream<app_user.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        return await _mapFirebaseUserToUser(firebaseUser);
      }
      return null;
    });
  }

  Future<app_user.User> _mapFirebaseUserToUser(
    firebase_auth.User firebaseUser, {
    GoogleSignInAccount? googleUser,
  }) async {
    // In a real app, you would fetch additional user data from your database
    // For now, we'll create a basic user object
    return app_user.User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? googleUser?.displayName ?? 'User',
      email: firebaseUser.email ?? googleUser?.email ?? '',
      profilePhotoUrl: firebaseUser.photoURL ?? googleUser?.photoUrl,
      bio: null, // Would come from database
      role: UserRole.mahasiswa, // Default role, would come from database
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    debugPrint('🔍 Handling Firebase Auth Exception: ${e.code}');
    
    switch (e.code) {
      case 'user-not-found':
        return 'Akun dengan email ini tidak ditemukan.';
      case 'wrong-password':
        return 'Password yang Anda masukkan salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'network-request-failed':
        return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
      case 'email-already-in-use':
        return 'Akun dengan email ini sudah terdaftar.';
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Login dengan email/password tidak diaktifkan.';
      case 'invalid-credential':
        return 'Kredensial login tidak valid.';
      default:
        debugPrint('❓ Unknown error code: ${e.code}');
        return 'Gagal login: ${e.message ?? e.code}';
    }
  }
}