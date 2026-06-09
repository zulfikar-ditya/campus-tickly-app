/// Simple form-field validators returning an error string, or null when valid.
abstract final class Validators {
  static String? requiredField(String? value, {String field = 'This field'}) {
    return (value == null || value.trim().isEmpty) ? '$field is required' : null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final RegExp re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(value.trim()) ? null : 'Enter a valid email';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return value.length < 6 ? 'Password must be at least 6 characters' : null;
  }

  /// Validator that a confirmation matches the value returned by [other].
  static FormFieldValidatorString matches(
    String Function() other, {
    String message = 'Passwords do not match',
  }) {
    return (String? value) => value == other() ? null : message;
  }
}

typedef FormFieldValidatorString = String? Function(String? value);
