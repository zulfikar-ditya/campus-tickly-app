/// A failure returned by the backend or the network layer.
///
/// The backend wraps errors as `{ status, success: false, message, errors? }`,
/// where `errors` is a list of `{ field, message }`. [fieldErrors] flattens that
/// into a `field -> message` map so forms can show inline messages.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.fieldErrors = const <String, String>{}});

  final String message;
  final int? statusCode;
  final Map<String, String> fieldErrors;

  /// True when the request failed because the user is not (or no longer)
  /// authenticated — the caller should send them back to sign in.
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
