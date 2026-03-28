// lib/core/utils/validators.dart
String? validateRequired(String? value, {String label = 'Field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required.';
  }
  return null;
}

String? validateEmail(String? value) {
  final String? required = validateRequired(value, label: 'Email');
  if (required != null) {
    return required;
  }
  final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailPattern.hasMatch(value!.trim())) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? value) {
  final String? required = validateRequired(value, label: 'Password');
  if (required != null) {
    return required;
  }
  if (value!.trim().length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

String? validatePasswordConfirmation(String? value, String original) {
  final String? passwordValidation = validatePassword(value);
  if (passwordValidation != null) {
    return passwordValidation;
  }
  if (value!.trim() != original.trim()) {
    return 'Passwords do not match.';
  }
  return null;
}
