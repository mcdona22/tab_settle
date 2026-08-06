import 'package:intl/intl.dart';

extension CurrencyFormatter on double {
  /// Formats a double into a localized currency string (e.g., 24.5 -> "£24.50")
  String toCurrency({String currencySymbol = '£', String locale = 'en_GB'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return formatter.format(this);
  }
}

extension NullableCurrencyFormatter on double? {
  /// Safely formats nullable doubles, returning a fallback string if null
  String toCurrency({String currencySymbol = '£', String fallback = '—'}) {
    if (this == null) return fallback;
    return this!.toCurrency(currencySymbol: currencySymbol);
  }
}
