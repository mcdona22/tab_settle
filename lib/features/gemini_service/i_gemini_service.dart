import 'package:tab_settle/features/bill_analyse/data/receipt_dto.dart';

abstract class IGeminiService {
  Future<ReceiptDto> analyseAssetReceipt(String path);
}
