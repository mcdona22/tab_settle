import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bill_submission_controller.g.dart';

@Riverpod(keepAlive: false)
class BillSubmissionController extends _$BillSubmissionController with UiLoggy {
  @override
  FutureOr<String> build() {
    return '';
  }

  Future<void> captureImageFromGallery() async {
    state = AsyncValue.loading();
    final picker = ImagePicker();
    state = await AsyncValue.guard(() async {
      final response = await picker.pickImage(source: ImageSource.gallery);
      final filePath = response!.path ?? "";
      loggy.debug('response created : $filePath');

      return filePath;
    });
  }

  // Future<void> analyseReceipt() async {
  //   state = const AsyncValue.loading();
  //   loggy.debug('Analysing ...');
  //
  //   await Future.delayed(Duration(seconds: 3));
  //   loggy.debug('wait complete');
  //
  //   final text = await ref.read(geminiServiceProvider).fetchGreeting();
  //   loggy.debug('api invocation complete: "$text"');
  //
  //   state = AsyncData(text);
  // }

  // Future<void> analyseAssetReceipt(String assetPath) async {
  //   state = AsyncValue.loading();
  //   state = await AsyncValue.guard(() async {
  //     final geminiService = ref.read(geminiServiceProvider);
  //     final ReceiptDto dto = await geminiService.analyseAssetReceipt(assetPath);
  //     loggy.debug(dto);
  //     return dto;
  //   });
  // }

  // Future<void> analyseTextReceipt(String textReceipt) async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(() async {
  //     final geminiService = ref.read(geminiServiceProvider);
  //     final ReceiptDto dto = await geminiService.analyseTextReceipt(
  //       textReceipt,
  //     );
  //     loggy.debug(dto);
  //     return dto;
  //   });
  // }
}
