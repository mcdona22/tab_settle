import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/service/gemini_service.dart';

part 'bill_scan_controller.g.dart';

@Riverpod(keepAlive: false)
class BillScanController extends _$BillScanController with UiLoggy {
  @override
  FutureOr<ReceiptDto?> build() {
    return null;
  }

  Future<void> analyseImageReceipt(String assetPath) async {
    state = AsyncValue.loading();
    final newState = await AsyncValue.guard(() async {
      final geminiService = ref.read(geminiServiceProvider);
      final ReceiptDto dto = await geminiService.analyseAssetReceipt(assetPath);
      loggy.debug(dto);
      return dto;
    });

    if (ref.mounted) state = newState;
  }
}
