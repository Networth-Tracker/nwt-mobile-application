import 'package:intl/intl.dart';

/// A utility class for formatting currency values in Indian Rupee format
/// with appropriate suffixes (K, L, Cr) based on the value.
class CurrencyFormatter {
  /// Formats a number as Indian Rupee with the ₹ symbol
  /// 
  /// Example: 1000 becomes ₹1,000
  static String formatRupee(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
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

  /// Formats a number with appropriate Indian suffixes (K, L, Cr)
  /// 
  /// Examples:
  /// - 1000 becomes 1K
  /// - 100000 becomes 1L
  /// - 10000000 becomes 1Cr
  static String formatWithSuffix(num amount) {
    if (amount < 1000) {
      return amount.toString();
    } else if (amount < 100000) {
      // Convert to K (thousands)
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
}
