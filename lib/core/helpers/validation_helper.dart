/// Common validation helper for auth and form fields.
/// Returns null when valid, or an error message when invalid.
class ValidationHelper {
  ValidationHelper._();

  // --- Email ---
  static const int emailMaxLength = 254;
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
  );

  /// Validates email: required, format, max length.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    if (trimmed.length > emailMaxLength) {
      return 'Email is too long';
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Returns true if email is valid (for UI indicators like check icon).
  static bool isEmailValid(String? value) {
    return validateEmail(value) == null;
  }

  // --- Password (login: required only) ---
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;

  /// Validates password for login: required only.
  static String? validatePasswordLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Validates password for signup: required, min/max length, strength.
  static String? validatePasswordSignup(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < passwordMinLength) {
      return 'Password must be at least $passwordMinLength characters';
    }
    if (value.length > passwordMaxLength) {
      return 'Password must be at most $passwordMaxLength characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`~]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validates confirm password matches.
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // --- Optional: name / full name ---
  static const int nameMinLength = 2;
  static const int nameMaxLength = 100;

  /// Validates full name (optional field): if provided, min/max length, letters/spaces only.
  static String? validateFullName(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Name is required' : null;
    }
    final trimmed = value.trim();
    if (trimmed.length < nameMinLength) {
      return 'Name must be at least $nameMinLength characters';
    }
    if (trimmed.length > nameMaxLength) {
      return 'Name must be at most $nameMaxLength characters';
    }
    if (!RegExp(r"^[a-zA-Z\s\-'.]+$").hasMatch(trimmed)) {
      return 'Name can only contain letters, spaces, hyphens and apostrophes';
    }
    return null;
  }

  /// Validates required (non-empty after trim).
  static String? validateRequired(
    String? value, [
    String fieldName = 'This field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
