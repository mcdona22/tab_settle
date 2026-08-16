import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt/data/firebase_providers.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';
import 'package:tab_settle/features/receipt/data/receipt_item_repository.dart';
import 'package:tab_settle/features/receipt/data/receipt_repository.dart';

part 'receipt_service.g.dart';

class ReceiptService {
  final ReceiptRepository receiptRepo;

  final ReceiptItemRepository itemRepo;

  ReceiptService({required this.receiptRepo, required this.itemRepo});

  Future<String> saveReceipt(Receipt receipt) async {
    final batch = receiptRepo.generateBatch();

    final id = await receiptRepo.writeDocument(receipt, batch: batch);
    final path = '${receiptRepo.collectionName}/$id';
    for (final item in receipt.items) {
      await itemRepo.writeDocument(item, batch: batch, customPath: path);
    }
    await batch.commit();
    return '';
  }
}

@Riverpod()
ReceiptService receiptService(Ref ref) {
  final receiptRepo = ref.watch(receiptRepositoryProvider);
  final itemRepo = ref.watch(receiptItemRepositoryProvider);

  return ReceiptService(receiptRepo: receiptRepo, itemRepo: itemRepo);
}
