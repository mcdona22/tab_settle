import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_item_repository.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt_repository.dart';

part 'firebase_providers.g.dart';

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
ReceiptRepository receiptRepository(Ref ref) =>
    ReceiptRepository(ref.watch(firebaseFirestoreProvider), "receipts");

@riverpod
ReceiptItemRepository receiptItemRepository(Ref ref) => ReceiptItemRepository(
  ref.watch(firebaseFirestoreProvider),
  "receipt-items",
);
