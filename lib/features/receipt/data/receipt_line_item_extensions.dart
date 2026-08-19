import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';

extension ReceiptLineItemListX on List<ReceiptLineItem> {
  List<ReceiptLineItem> claimedBy(String claimant) =>
      where((item) => item.claimant == claimant).toList();

  List<ReceiptLineItem> get unclaimed => claimedBy('');

  double get totalPrice => fold(0.0, (sum, item) => sum + item.price);
}
