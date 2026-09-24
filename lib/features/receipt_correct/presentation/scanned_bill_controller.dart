import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt_dashboard/application/receipt_service.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';

part 'scanned_bill_controller.g.dart';

@Riverpod(keepAlive: false)
class ScannedBillController extends _$ScannedBillController with UiLoggy {
  @override
  FutureOr<void> build() {}

  Future<String> saveReceipt(Receipt receipt) async {
    state = const AsyncValue.loading();
    final service = ref.read(receiptServiceProvider);
    String? receiptId;
    final result = await AsyncValue.guard(() async {
      receiptId = await service.saveReceipt(receipt);
    });

    if (ref.mounted) state = result;
    if (result.hasError) throw result.error!;

    return receiptId!;
  }
}
