import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';
import 'package:tab_settle/features/bill_analyse/service/gemini_service.dart';

part 'bill_scan_provider.g.dart';

@riverpod
Future<ReceiptDto> receiptScan(Ref ref, String filePath) async {
  final geminiService = ref.watch(geminiServiceProvider);
  return geminiService.analyseAssetReceipt(filePath);
}
