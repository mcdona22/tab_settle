import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';

part 'receipt_dashboard_controller.g.dart';

@riverpod
class ReceiptDashboardController extends _$ReceiptDashboardController
    with UiLoggy {
  @override
  FutureOr<void> build() {}

  Future<void> updateReceiptItem(ReceiptLineItem item, String receiptId) async {
    final receiptService = ref.read(receiptServiceProvider);

    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(
      () => receiptService.updateReceipt(item, receiptId),
    );

    if (ref.mounted) {
      state = result;
    }
  }
}
