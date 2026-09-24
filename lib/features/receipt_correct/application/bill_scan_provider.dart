import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/gemini_service/gemini_service_providers.dart';
import 'package:tab_settle/features/receipt_correct/data/receipt_dto.dart';

part 'bill_scan_provider.g.dart';

@riverpod
Future<ReceiptDto> receiptScan(Ref ref, XFile xFile) async {
  final geminiService = ref.watch(geminiServiceProvider);
  return geminiService.analyseAssetReceipt(xFile);
}
