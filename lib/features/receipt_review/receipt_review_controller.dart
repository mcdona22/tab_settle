import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/gemini_service/gemini_service_providers.dart';

part 'receipt_review_controller.g.dart';

@riverpod
class ReceiptReviewController extends _$ReceiptReviewController with UiLoggy {
  @override
  FutureOr<ReceiptDto?> build() => null;

  void analyseImage(XFile xFile) async {
    state = AsyncValue.loading();

    loggy.debug('Analysing the image in ${xFile.name}');
    state = await AsyncValue.guard(() async {
      final dto = ref.read(geminiServiceProvider).analyseAssetReceipt(xFile);
      loggy.debug('dto:', dto);
      return dto;
    });
    if (state.hasError) throw state.error!;
  }
}
