import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppValidators {
  /// Validates phone number - accepts any numeric input
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Generic validation - just check if it's a reasonable length
    if (digitsOnly.length < 6 || digitsOnly.length > 15) {
      return 'Enter a valid phone number';
    }
    
    return null;
  }

  static String? validatePanCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'PAN number is required';
    }
    
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    
    if (!panRegex.hasMatch(value)) {
      return 'Enter a valid PAN number';
    }
    
    return null;
  }

  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'First name cannot exceed 50 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
      return 'First name can only contain letters, spaces and hyphens';
    }
    
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    
    if (value.length > 50) {
      return 'Last name cannot exceed 50 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
      return 'Last name can only contain letters, spaces and hyphens';
    }
    
    return null;
  }

  static String? validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    
    try {
      final date = DateFormat('dd/MM/yyyy').parse(value);
      final now = DateTime.now();
      
      if (date.isAfter(now)) {
        return 'Date of birth cannot be in the future';
      }
    
      final age = now.year - date.year - 
          (now.month > date.month || 
          (now.month == date.month && now.day >= date.day) ? 0 : 1);
      
      if (age < 18) {
        return 'You must be at least 18 years old';
      }
      
      if (age > 120) {
        return 'Please enter a valid date of birth';
      }
    } catch (e) {
      return 'Enter a valid date in DD/MM/YYYY format';
    }
    
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
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
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }
}

/// Collection of input formatters for various form fields
class AppInputFormatters {
  /// Input formatter for phone numbers - accepts any digits
  static List<TextInputFormatter> phoneFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(15),
    ];
  }

  /// Input formatter for PAN Card
  static List<TextInputFormatter> panCardFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
      LengthLimitingTextInputFormatter(10),
      _UpperCaseTextFormatter(),
      // Custom PAN formatter: AAAAA0000A
      _PanCardFormatter(),
    ];
  }

  /// Input formatter for first name
  static List<TextInputFormatter> firstNameFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\-]')),
      LengthLimitingTextInputFormatter(50),
      // Capitalize first letter
      _CapitalizeFirstLetterFormatter(),
    ];
  }

  /// Input formatter for last name
  static List<TextInputFormatter> lastNameFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s\-]')),
      LengthLimitingTextInputFormatter(50),
      // Capitalize first letter
      _CapitalizeFirstLetterFormatter(),
    ];
  }

  /// Input formatter for date of birth (DD/MM/YYYY format)
  static List<TextInputFormatter> dobFormatters() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(8),
      _DateInputFormatter(),
    ];
  }
}

/// Custom formatter to convert text to uppercase
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Custom formatter to capitalize first letter of each word
class _CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Capitalize first letter of each word
    final words = newValue.text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + (word.length > 1 ? word.substring(1) : '');
    }).join(' ');
    
    return TextEditingValue(
      text: capitalizedWords,
      selection: newValue.selection,
    );
  }
}

/// Custom formatter for PAN Card
class _PanCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    // Format check for PAN pattern: AAAAA0000A
    if (text.length > 5) {
      // Check if characters 6-9 are digits
      final subStringToCheck = text.substring(5, min(text.length, 9));
      for (int i = 0; i < subStringToCheck.length; i++) {
        if (!RegExp(r'[0-9]').hasMatch(subStringToCheck[i])) {
          // If not digits, reject the change
          return oldValue;
        }
      }
    }
    
    if (text.length >= 10 && !RegExp(r'[A-Za-z]').hasMatch(text[9])) {
      // If the 10th character is not an alphabet, reject the change
      return oldValue;
    }
    
    return newValue;
  }
}

/// Custom formatter for date input (DD/MM/YYYY)
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    
    if (oldValue.text.length >= text.length) {
      return newValue;
    }
    
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      
      if (nonZeroIndex == 2 || nonZeroIndex == 4) {
        if (nonZeroIndex < text.length && text[nonZeroIndex] != '/') {
          buffer.write('/');
        }
      }
    }
    
    var string = buffer.toString();
    
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// Helper function for min (used in PAN formatter)
int min(int a, int b) => a < b ? a : b;