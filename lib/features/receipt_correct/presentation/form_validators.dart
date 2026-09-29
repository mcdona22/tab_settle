abstract class FormValidators {
  static String? requiredName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name cannot be empty';
    return null;
  }

  static String? nonNegativeInteger(String? value) {
    if (value == null || value.trim().isEmpty) return 'Quantity is required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Not valid';
    if (parsed < 0) return 'Not allowed';

    return null;
  }

  static String? nonNegativePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Quantity is required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Not valid';
    if (parsed < 0) return 'Not allowed';

    return null;
  }
}
