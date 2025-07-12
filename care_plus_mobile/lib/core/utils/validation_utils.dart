import 'dart:math';

/// Validation utility functions
class ValidationUtils {
  /// Email validation
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  /// Phone number validation
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegExp.hasMatch(phoneNumber);
  }

  /// Password strength validation
  static bool isValidPassword(String password) {
    // At least 8 characters, one uppercase, one lowercase, one digit, one special character
    final passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  /// Get password strength score (0-4)
  static int getPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[@$!%*?&]'))) score++;

    return score;
  }

  /// Get password strength description
  static String getPasswordStrengthDescription(String password) {
    final strength = getPasswordStrength(password);
    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Medium';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }

  /// Name validation
  static bool isValidName(String name) {
    final nameRegExp = RegExp(r'^[a-zA-Z\s]{2,50}$');
    return nameRegExp.hasMatch(name.trim());
  }

  /// Medication dosage validation
  static bool isValidDosage(String dosage) {
    final dosageRegExp = RegExp(
      r'^\d+(\.\d+)?\s*(mg|g|ml|units?|tablets?|capsules?)$',
      caseSensitive: false,
    );
    return dosageRegExp.hasMatch(dosage.trim());
  }

  /// Blood pressure validation
  static bool isValidBloodPressure(String systolic, String diastolic) {
    try {
      final sys = int.parse(systolic);
      final dia = int.parse(diastolic);
      return sys >= 70 && sys <= 250 && dia >= 40 && dia <= 150 && sys > dia;
    } catch (e) {
      return false;
    }
  }

  /// Heart rate validation
  static bool isValidHeartRate(String heartRate) {
    try {
      final rate = int.parse(heartRate);
      return rate >= 30 && rate <= 220;
    } catch (e) {
      return false;
    }
  }

  /// Temperature validation (Celsius)
  static bool isValidTemperature(String temperature) {
    try {
      final temp = double.parse(temperature);
      return temp >= 30.0 && temp <= 45.0;
    } catch (e) {
      return false;
    }
  }

  /// Weight validation
  static bool isValidWeight(String weight) {
    try {
      final w = double.parse(weight);
      return w >= 1.0 && w <= 500.0; // kg
    } catch (e) {
      return false;
    }
  }

  /// Age validation
  static bool isValidAge(int age) {
    return age >= 0 && age <= 150;
  }

  /// Date of birth validation
  static bool isValidDateOfBirth(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.year - dateOfBirth.year;
    return age >= 0 && age <= 150 && dateOfBirth.isBefore(now);
  }

  /// License number validation (basic)
  static bool isValidLicenseNumber(String licenseNumber) {
    final licenseRegExp = RegExp(r'^[A-Z0-9]{6,20}$');
    return licenseRegExp.hasMatch(licenseNumber.toUpperCase());
  }

  /// URL validation
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Check if string is not empty after trimming
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Check if string length is within range
  static bool isLengthValid(String value, {int min = 0, int max = 255}) {
    return value.length >= min && value.length <= max;
  }

  /// Check if value is numeric
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  /// Check if value is integer
  static bool isInteger(String value) {
    return int.tryParse(value) != null;
  }

  /// Sanitize input string
  static String sanitizeInput(String input) {
    return input.trim().replaceAll(RegExp(r'''[<>"'']'''), '');
  }

  /// Check if date is in the future
  static bool isFutureDate(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Check if date is in the past
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Validate medication frequency
  static bool isValidFrequency(int timesPerDay, int intervalHours) {
    return timesPerDay > 0 &&
        timesPerDay <= 6 &&
        intervalHours > 0 &&
        intervalHours <= 24 &&
        (24 % intervalHours == 0 || timesPerDay * intervalHours <= 24);
  }

  /// Generate validation error message
  static String getValidationError(String field, String rule) {
    switch (rule) {
      case 'required':
        return '$field is required';
      case 'email':
        return 'Please enter a valid email address';
      case 'phone':
        return 'Please enter a valid phone number';
      case 'password':
        return 'Password must be at least 8 characters with uppercase, lowercase, number and special character';
      case 'name':
        return 'Please enter a valid name (2-50 characters, letters only)';
      case 'age':
        return 'Please enter a valid age (0-150)';
      case 'weight':
        return 'Please enter a valid weight (1-500 kg)';
      case 'heartRate':
        return 'Please enter a valid heart rate (30-220 bpm)';
      case 'temperature':
        return 'Please enter a valid temperature (30-45°C)';
      case 'bloodPressure':
        return 'Please enter valid blood pressure values';
      case 'dosage':
        return 'Please enter a valid dosage (e.g., "10 mg", "2 tablets")';
      case 'url':
        return 'Please enter a valid URL';
      case 'date':
        return 'Please enter a valid date';
      default:
        return '$field is invalid';
    }
  }
}

/// String utility functions
class StringUtils {
  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    return text
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1).toLowerCase()
              : '',
        )
        .join(' ');
  }

  /// Capitalize first letter only
  static String capitalize(String text) {
    return text.isNotEmpty
        ? text[0].toUpperCase() + text.substring(1).toLowerCase()
        : '';
  }

  /// Convert to title case
  static String toTitleCase(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate string with ellipsis
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Remove extra whitespace
  static String cleanWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Generate initials from name
  static String getInitials(String name, {int maxLength = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
    return initials.length > maxLength
        ? initials.substring(0, maxLength)
        : initials;
  }

  /// Mask sensitive information
  static String maskString(
    String text, {
    int visibleStart = 2,
    int visibleEnd = 2,
    String maskChar = '*',
  }) {
    if (text.length <= visibleStart + visibleEnd) return text;
    final start = text.substring(0, visibleStart);
    final end = text.substring(text.length - visibleEnd);
    final maskLength = text.length - visibleStart - visibleEnd;
    return start + maskChar * maskLength + end;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Generate random string
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Check if string contains only digits
  static bool isDigitsOnly(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  /// Check if string contains only letters
  static bool isLettersOnly(String text) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }

  /// Check if string contains only alphanumeric characters
  static bool isAlphanumeric(String text) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(text);
  }

  /// Remove HTML tags
  static String removeHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Convert snake_case to camelCase
  static String snakeToCamel(String snake) {
    return snake.split('_').asMap().entries.map((entry) {
      return entry.key == 0 ? entry.value : capitalize(entry.value);
    }).join();
  }

  /// Convert camelCase to snake_case
  static String camelToSnake(String camel) {
    return camel.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
