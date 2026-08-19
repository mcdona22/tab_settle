import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt/data/firebase_providers.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';
import 'package:tab_settle/features/receipt/data/receipt_item_repository.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';
import 'package:tab_settle/features/receipt/data/receipt_repository.dart';
import 'package:tab_settle/features/receipt_history/data/receipt_history_notifier.dart';

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
    return id;
  }

  Future<void> updateReceipt(ReceiptLineItem item, String receiptId) async {
    await itemRepo.updateDocument(
      item,
      '${receiptRepo.collectionName}/$receiptId',
    );
  }

  Future<Receipt?> getReceipt(String id) async {
    return receiptRepo.fetchDocument(id);
  }
}

@Riverpod()
ReceiptService receiptService(Ref ref) {
  final receiptRepo = ref.watch(receiptRepositoryProvider);
  final itemRepo = ref.watch(receiptItemRepositoryProvider);

  return ReceiptService(receiptRepo: receiptRepo, itemRepo: itemRepo);
}

@riverpod
Future<Receipt> receiptHeader(Ref ref, String receiptId) async {
  final service = ref.watch(receiptServiceProvider);
  final receipt = await service.getReceipt(receiptId);
  if (receipt == null) {
    throw Exception('Receipt $receiptId not found.');
  }
  ref.watch(receiptHistoryProvider.notifier).addVisitedReceipt(receipt);
  return receipt;
}

@riverpod
Stream<List<ReceiptLineItem>> receiptItems(Ref ref, String receiptId) {
  final itemsRepo = ref.watch(receiptItemRepositoryProvider);
  final receiptRepo = ref.watch(receiptRepositoryProvider);
  return itemsRepo.watchCollection(
    customPath: '${receiptRepo.collectionName}/$receiptId',
  );
}

@riverpod
String receiptId(Ref ref) {
  throw UnimplementedError(
    'receiptIdProvider must be overridden in a ProviderScope',
  );
}
