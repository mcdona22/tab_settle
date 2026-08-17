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
      final filePath = response!.path;
      loggy.debug('response created : $filePath');

      return filePath;
    });
  }
}
