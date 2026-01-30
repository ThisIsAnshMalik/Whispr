import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispr_app/core/common/common_snackbar.dart';
import 'package:whispr_app/core/models/user_model.dart';
import 'package:whispr_app/core/services/local_database_service.dart';

/// Global session controller for user authentication state.
class SessionController extends GetxController {
  static SessionController get to => Get.find<SessionController>();

  static const String _sessionKey = 'user_session_id';

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final isLoading = false.obs;
  final isInitialized = false.obs;

  /// Whether a user is currently logged in.
  bool get isLoggedIn => currentUser.value != null;

  /// Current user's email (or 'Anonymous' if not logged in).
  String get userEmail => currentUser.value?.email ?? 'Anonymous';

  /// Current user's display name (or 'Anonymous' if not set).
  String get displayName => currentUser.value?.displayName ?? 'Anonymous';

  @override
  void onInit() {
    super.onInit();
    _initSession();
  }

  /// Initialize session by checking for existing login.
  Future<void> _initSession() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt(_sessionKey);

      if (userId != null) {
        final user = await LocalDatabaseService.instance.getUser(userId);
        if (user != null) {
          currentUser.value = user;
        } else {
          // User no longer exists, clear session
          await prefs.remove(_sessionKey);
        }
      }
    } catch (e) {
      debugPrint('Error initializing session: $e');
    } finally {
      isLoading.value = false;
      isInitialized.value = true;
    }
  }

  /// Hash password using SHA-256.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Attempt to login with email and password.
  /// Returns true if successful, false otherwise.
  Future<bool> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final user = await LocalDatabaseService.instance.getUserByEmail(
        email.trim().toLowerCase(),
      );

      if (user == null) {
        CommonSnackbar.showError(
          context,
          message: 'No account found with this email',
        );
        return false;
      }

      final passwordHash = _hashPassword(password);
      if (user.passwordHash != passwordHash) {
        CommonSnackbar.showError(context, message: 'Incorrect password');
        return false;
      }

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_sessionKey, user.id!);
      currentUser.value = user;

      CommonSnackbar.showSuccess(context, message: 'Login successful');
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      CommonSnackbar.showError(
        context,
        message: 'Login failed. Please try again.',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new account and automatically log in.
  /// Returns true if successful, false otherwise.
  Future<bool> signup(
    BuildContext context, {
    required String email,
    required String password,
    String? displayName,
  }) async {
    isLoading.value = true;
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // Check if email already exists
      final existingUser = await LocalDatabaseService.instance.getUserByEmail(
        normalizedEmail,
      );
      if (existingUser != null) {
        CommonSnackbar.showError(
          context,
          message: 'An account with this email already exists',
        );
        return false;
      }

      // Create user
      final passwordHash = _hashPassword(password);
      final newUser = UserModel(
        email: normalizedEmail,
        passwordHash: passwordHash,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      final createdUser = await LocalDatabaseService.instance.insertUser(
        newUser,
      );

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_sessionKey, createdUser.id!);
      currentUser.value = createdUser;

      CommonSnackbar.showSuccess(
        context,
        message: 'Account created successfully',
      );
      return true;
    } catch (e) {
      debugPrint('Signup error: $e');
      CommonSnackbar.showError(
        context,
        message: 'Signup failed. Please try again.',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Log out the current user.
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
      currentUser.value = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Change the current user's password.
  Future<bool> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentUser.value == null) {
      CommonSnackbar.showError(context, message: 'No user logged in');
      return false;
    }

    isLoading.value = true;
    try {
      final currentHash = _hashPassword(currentPassword);
      if (currentUser.value!.passwordHash != currentHash) {
        CommonSnackbar.showError(
          context,
          message: 'Current password is incorrect',
        );
        return false;
      }

      final newHash = _hashPassword(newPassword);
      await LocalDatabaseService.instance.updateUserPassword(
        currentUser.value!.id!,
        newHash,
      );

      currentUser.value = currentUser.value!.copyWith(passwordHash: newHash);
      CommonSnackbar.showSuccess(
        context,
        message: 'Password changed successfully',
      );
      return true;
    } catch (e) {
      debugPrint('Change password error: $e');
      CommonSnackbar.showError(context, message: 'Failed to change password');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete the current user's account.
  Future<bool> deleteAccount(BuildContext context) async {
    if (currentUser.value == null) {
      CommonSnackbar.showError(context, message: 'No user logged in');
      return false;
    }

    isLoading.value = true;
    try {
      await LocalDatabaseService.instance.deleteUser(currentUser.value!.id!);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
      currentUser.value = null;

      return true;
    } catch (e) {
      debugPrint('Delete account error: $e');
      CommonSnackbar.showError(context, message: 'Failed to delete account');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update display name.
  Future<bool> updateDisplayName(
    BuildContext context,
    String newDisplayName,
  ) async {
    if (currentUser.value == null) return false;

    try {
      await LocalDatabaseService.instance.updateUserDisplayName(
        currentUser.value!.id!,
        newDisplayName.trim(),
      );
      currentUser.value = currentUser.value!.copyWith(
        displayName: newDisplayName.trim(),
      );
      CommonSnackbar.showSuccess(context, message: 'Display name updated');
      return true;
    } catch (e) {
      debugPrint('Update display name error: $e');
      CommonSnackbar.showError(
        context,
        message: 'Failed to update display name',
      );
      return false;
    }
  }

  /// Reset password for a user (used in forgot password flow).
  /// Does not require current password - user identity verified via email.
  Future<bool> resetPassword(
    BuildContext context, {
    required int userId,
    required String newPassword,
  }) async {
    isLoading.value = true;
    try {
      final newHash = _hashPassword(newPassword);
      await LocalDatabaseService.instance.updateUserPassword(userId, newHash);
      return true;
    } catch (e) {
      debugPrint('Reset password error: $e');
      CommonSnackbar.showError(context, message: 'Failed to reset password');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
