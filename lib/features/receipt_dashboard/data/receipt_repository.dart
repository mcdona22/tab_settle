import 'package:tab_settle/db/abstract_document.dart';
import 'package:tab_settle/db/abstract_repository.dart';
import 'package:tab_settle/features/receipt_dashboard/data/receipt.dart';

class ReceiptRepository extends AbstractRepository<Receipt> {
  ReceiptRepository(super.firestore, super.collectionName);

  @override
  Receipt fromFirestore(DocID id, Map<String, dynamic> data) =>
      Receipt.fromJson({...data, 'id': id, 'items': []});
}
