import 'dart:convert';

extension MapJsonX on Map<String, dynamic> {
  /// Converts the map into a formatted, multi-line JSON string.
  ///
  /// Useful for UI debug views and log output.
  String toPrettyJson({String indent = '  '}) {
    return JsonEncoder.withIndent(indent).convert(this);
  }
}
