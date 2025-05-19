import 'package:intl/intl.dart';

/// A utility class for formatting currency values in Indian Rupee format
/// with appropriate suffixes (K, L, Cr) based on the value.
class CurrencyFormatter {
  /// Formats a number as Indian Rupee with the ₹ symbol and appropriate suffix
  /// 
  /// Examples:
  /// - 1000 becomes ₹1,000
  /// - 100000 becomes ₹1L
  /// - 10000000 becomes ₹1Cr
  static String formatRupee(num amount) {
    if (amount >= 10000000) { // 1 Crore
      final crores = amount / 10000000;
      return '₹${crores.toStringAsFixed(crores.truncateToDouble() == crores ? 0 : 1)}Cr';
    } else if (amount >= 100000) { // 1 Lakh
      final lakhs = amount / 100000;
      return '₹${lakhs.toStringAsFixed(lakhs.truncateToDouble() == lakhs ? 0 : 1)}L';
    } else if (amount >= 1000) { // 1 Thousand (for 4 and 5 digit numbers)
      final thousands = amount / 1000;
      return '₹${thousands.toStringAsFixed(thousands.truncateToDouble() == thousands ? 0 : 1)}K';
    } else {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    }
  }

  /// Formats a number as Indian Rupee with the ₹ symbol and 2 decimal places
  /// 
  /// Example: 1000.50 becomes ₹1,000.50
  static String formatRupeeWithDecimals(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Formats a number with appropriate Indian suffixes (L, Cr)
  /// 
  /// Examples:
  /// - 1000 becomes 1K
  /// - 100000 becomes 1L
  /// - 10000000 becomes 1Cr
  static String formatWithSuffix(num amount) {
    if (amount < 1000) {
      return amount.toString();
    } else if (amount < 100000) {
      // Convert to K (thousands) for both 4 and 5 digit numbers
      final value = amount / 1000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}K';
    } else if (amount < 10000000) {
      // Convert to L (lakhs)
      final value = amount / 100000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}L';
    } else {
      // Convert to Cr (crores)
      final value = amount / 10000000;
      return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)}Cr';
    }
  }

  /// Formats a number as Indian Rupee with the ₹ symbol and appropriate suffixes (K, L, Cr)
  /// 
  /// Examples:
  /// - 1000 becomes ₹1K
  /// - 100000 becomes ₹1L
  /// - 10000000 becomes ₹1Cr
  static String formatRupeeWithSuffix(num amount) {
    return '₹${formatWithSuffix(amount)}';
  }

  /// Formats a number as Indian Rupee with the ₹ symbol and compact notation
  /// This is useful for displaying large numbers in a compact form
  /// 
  /// Examples:
  /// - 1000 becomes ₹1K
  /// - 1500 becomes ₹1.5K
  /// - 1000000 becomes ₹1M
  static String formatCompact(num amount) {
    final formatter = NumberFormat.compactCurrency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }
  
  /// Formats a number as Indian Rupee with the ₹ symbol and commas only
  /// Does not use any suffixes like K, L, or Cr
  /// 
  /// Examples:
  /// - 1000 becomes ₹1,000
  /// - 100000 becomes ₹1,00,000
  /// - 10000000 becomes ₹1,00,00,000
  static String formatRupeeWithCommas(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
