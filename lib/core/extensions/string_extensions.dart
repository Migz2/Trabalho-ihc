/// String extension utilities
extension StringExtension on String {
  /// Check if string is empty or null
  bool get isEmpty => trim().length == 0;

  /// Check if string is not empty
  bool get isNotEmpty => trim().length > 0;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Capitalize all words
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Remove leading whitespace
  String get removeLeadingWhitespace => replaceAll(RegExp(r'^\s+'), '');

  /// Remove trailing whitespace
  String get removeTrailingWhitespace => replaceAll(RegExp(r'\s+$'), '');

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^[0-9]+$').hasMatch(this);

  /// Check if string contains only letters
  bool get isAlpha => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Check if string is alphanumeric
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);

  /// Reverse string
  String get reverse => split('').reversed.join('');

  /// Get first character
  String get first => isEmpty ? '' : this[0];

  /// Get last character
  String get last => isEmpty ? '' : this[length - 1];

  /// Truncate string to max length with ellipsis
  String truncate(int maxLength, [String ellipsis = '...']) {
    if (length <= maxLength) return this;
    return substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  /// Count occurrences of a substring
  int countOccurrences(String substring) {
    if (substring.isEmpty) return 0;
    return split(substring).length - 1;
  }

  /// Convert camelCase to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    ).toLowerCase();
  }

  /// Convert snake_case to camelCase
  String get toCamelCase {
    return split('_').asMap().entries.map((entry) {
      if (entry.key == 0) return entry.value;
      return entry.value.capitalize;
    }).join();
  }

  /// Convert to title case
  String get toTitleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Get initials from a name
  /// e.g., "John Doe" => "JD"
  String get getInitials {
    final parts = split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  /// Check if string is a palindrome
  bool get isPalindrome {
    final clean = removeWhitespace.toLowerCase();
    return clean == clean.reverse;
  }

  /// Repeat string n times
  String repeat(int times) {
    if (times <= 0) return '';
    return List<String>.filled(times, this).join();
  }

  /// Get similarity ratio with another string (0.0 to 1.0)
  double similarityTo(String other) {
    if (isEmpty && other.isEmpty) return 1.0;
    if (isEmpty || other.isEmpty) return 0.0;

    final s1 = this;
    final s2 = other;
    final longer = s1.length > s2.length ? s1 : s2;
    final shorter = s1.length > s2.length ? s2 : s1;

    if (longer.isEmpty) return 1.0;

    final editDistance = _levenshteinDistance(shorter, longer);
    return (longer.length - editDistance) / longer.length;
  }

  /// Calculate Levenshtein distance (edit distance)
  static int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    final d = List<List<int>>.generate(
      len1 + 1,
      (i) => List<int>.filled(len2 + 1, 0),
    );

    for (int i = 0; i <= len1; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= len2; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        d[i][j] = [d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost]
            .reduce((a, b) => a < b ? a : b);
      }
    }

    return d[len1][len2];
  }
}
