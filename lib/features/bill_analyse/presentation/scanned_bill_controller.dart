import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt/application/receipt_service.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

part 'scanned_bill_controller.g.dart';

@Riverpod(keepAlive: false)
class ScannedBillController extends _$ScannedBillController with UiLoggy {
  ReceiptService get _receiptService => ref.read(receiptServiceProvider);

  @override
  FutureOr<void> build() {}

  Future<String> saveReceipt(Receipt receipt) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      return await _receiptService.saveReceipt(receipt);
    });

    state = result.when(
      data: (_) => const AsyncData(null),
      error: (e, st) => AsyncValue.error(e, st),
      loading: () => const AsyncValue.loading(),
    );

    return result.requireValue;
  }
}
