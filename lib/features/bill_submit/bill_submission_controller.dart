import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/gemini_service/gemini_service.dart';
import 'package:tab_settle/features/gemini_service/gemini_service_providers.dart';

import '../bill_analyse/data/receipt_dto.dart';

part 'bill_submission_controller.g.dart';

@Riverpod(keepAlive: false)
class BillSubmissionController extends _$BillSubmissionController with UiLoggy {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<String?> captureImageFromGallery() async {
    state = AsyncValue.loading();
    final picker = ImagePicker();

    String? path;
    state = await AsyncValue.guard(() async {
      final response = await picker.pickImage(source: ImageSource.gallery);
      path = response?.path;
      loggy.debug('response created : $path');
    });
    if (state.hasError) throw state.error!;
    return path;
  }

  Future<ReceiptDto?> analyseImage(String fileName) async {
    state = AsyncValue.loading();

    ReceiptDto? dto;
    state = await AsyncValue.guard(() async {
      dto = await ref.read(geminiServiceProvider).analyseAssetReceipt(fileName);
    });
    if (state.hasError) throw state.error!;
    return dto;
  }
}
