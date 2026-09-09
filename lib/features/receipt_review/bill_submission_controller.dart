import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/gemini_service/gemini_service_providers.dart';

import '../bill_analyse/data/receipt_dto.dart';

part 'bill_submission_controller.g.dart';

@Riverpod(keepAlive: false)
class BillSubmissionController extends _$BillSubmissionController with UiLoggy {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<XFile?> captureImageFromGallery() async {
    state = AsyncValue.loading();
    final picker = ImagePicker();

    XFile? pickedFile;
    state = await AsyncValue.guard(() async {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      loggy.debug('response created : ${pickedFile?.name}');
    });
    if (state.hasError) throw state.error!;
    return pickedFile;
  }

  Future<ReceiptDto?> analyseImage(XFile xFile) async {
    state = AsyncValue.loading();

    ReceiptDto? dto;
    state = await AsyncValue.guard(() async {
      dto = await ref.read(geminiServiceProvider).analyseAssetReceipt(xFile);
    });
    if (state.hasError) throw state.error!;
    return dto;
  }
}
