import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tab_settle/features/receipt/data/receipt_repository.dart';

part 'firebase_providers.g.dart';

@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
ReceiptRepository receiptRepository(Ref ref) =>
    ReceiptRepository(ref.watch(firebaseFirestoreProvider));
