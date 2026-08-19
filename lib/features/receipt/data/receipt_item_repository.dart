import 'package:tab_settle/db/abstract_document.dart';
import 'package:tab_settle/db/abstract_repository.dart';
import 'package:tab_settle/features/receipt/data/receipt_line_item.dart';

class ReceiptItemRepository extends AbstractRepository<ReceiptLineItem> {
  ReceiptItemRepository(super.firestore, super.collectionName);

  @override
  ReceiptLineItem fromFirestore(DocID id, Map<String, dynamic> data) =>
      ReceiptLineItem.fromJson({...data, 'id': id});
}
