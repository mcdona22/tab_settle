import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loggy/loggy.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

class ReceiptRepository with UiLoggy {
  final FirebaseFirestore _firestore;

  ReceiptRepository(this._firestore);

  CollectionReference<Receipt> get _receiptsRef => _firestore
      .collection('receipts')
      .withConverter<Receipt>(
        fromFirestore: (snapshot, _) =>
            Receipt.fromJson(snapshot.data()!..['id'] = snapshot.id),
        toFirestore: (receipt, _) => receipt.toJson()..remove('id'),
      );

  Future<String> saveReceipt(Receipt receipt) async {
    loggy.debug('saving $receipt');
    final docRef = (receipt.id == null || receipt.id!.isEmpty)
        ? _receiptsRef.doc()
        : _receiptsRef.doc(receipt.id);

    await docRef.set(receipt);
    loggy.debug('Saved with an id of ${docRef.id}');

    return docRef.id;
  }
}
