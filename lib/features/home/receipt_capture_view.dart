import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/core/presentation/action_button.dart';
import 'package:tab_settle/features/home/receipt_capture_controller.dart';

class ReceiptCaptureView extends HookConsumerWidget with UiLoggy {
  const ReceiptCaptureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(receiptCaptureControllerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionButton(
          label: 'Find Receipt',
          icon: Icon(Icons.photo_library),
          onPressed: () => controller.captureImage(ImageSource.gallery),
        ),
        ActionButton(
          label: 'Snap Receipt',
          icon: Icon(Icons.camera),
          onPressed: () => controller.captureImage(ImageSource.camera),
        ),
      ],
    );
  }
}
