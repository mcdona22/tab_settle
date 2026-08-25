import 'package:tab_settle/features/receipt_dashboard/data/receipt_line_item.dart';

extension ReceiptLineItemListX on List<ReceiptLineItem> {
  List<ReceiptLineItem> claimedBy(String claimant) =>
      where((item) => item.claimant == claimant).toList();

  List<ReceiptLineItem> get unclaimed => claimedBy('');

  List<ReceiptLineItem> sortedByPriceDescending() =>
      [...this]..sort(_compareReceiptItemByPriceDesc);

  List<String> get claimants => this
      .where((item) => item.claimant.isNotEmpty)
      .map((item) => item.claimant)
      .toSet()
      .toList();

  void sortByPriceDescending() {
    sort(_compareReceiptItemByPriceDesc);
  }

  double get totalPrice => fold(0.0, (sum, item) => sum + item.price);

  int _compareReceiptItemByPriceDesc(ReceiptLineItem a, ReceiptLineItem b) {
    return b.price.compareTo(a.price);
  }
}
