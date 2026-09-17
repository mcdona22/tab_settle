import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_capture_controller.g.dart';

@riverpod
class ReceiptCaptureController extends _$ReceiptCaptureController with UiLoggy {
  @override
  FutureOr<XFile?> build() {
    return null;
  }

  void captureImage(ImageSource source) async {
    loggy.debug('Capturing image from ${source.name}');
    state = AsyncValue.loading();
    final picker = ImagePicker();

    state = await AsyncValue.guard(() async {
      final XFile? pickedFile = await picker.pickImage(source: source);
      loggy.debug('File selected is ${pickedFile != null} ');
      loggy.debug('Image path : ${pickedFile?.name ?? "None"}');
      return pickedFile;
    });
    if (state.hasError) throw state.error!;
  }
}
