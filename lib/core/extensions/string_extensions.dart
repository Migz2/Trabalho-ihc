/// Extensions for String
extension StringExtensions on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is a valid email
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is numeric
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  /// Check if string is alphanumeric
  bool isAlphanumeric() {
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericRegex.hasMatch(this);
  }

  /// Truncate string to maximum length
  String truncate({required int maxLength, String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Remove all whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Remove leading and trailing whitespace and condense internal whitespace
  String normalizeWhitespace() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Check if string is empty or only whitespace
  bool get isBlankString => trim().isEmpty;

  /// Check if string is not empty and not only whitespace
  bool get isNotBlank => !isBlankString;

  /// Convert string to Title Case
  String toTitleCase() {
    return split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }

  /// Convert to snake_case
  String toSnakeCase() {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .toLowerCase()
        .replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String toCamelCase() {
    final parts = split(RegExp(r'[\s_-]+'));
    return '${parts.first.toLowerCase()}${parts.skip(1).map((part) => part.capitalize()).join()}';
  }

  /// Check if string contains only digits
  bool get isDigitsOnly {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Check if string is URL
  bool isValidUrl() {
    try {
      Uri.parse(this);
      return this.startsWith('http://') || this.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  /// Get first N characters
  String firstN(int n) {
    if (length <= n) return this;
    return substring(0, n);
  }

  /// Get last N characters
  String lastN(int n) {
    if (length <= n) return this;
    return substring(length - n);
  }
}
