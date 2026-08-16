import 'package:tab_settle/db/abstract_repository.dart';
import 'package:tab_settle/features/receipt/data/receipt.dart';

class ReceiptRepository extends AbstractRepository<Receipt> {
  ReceiptRepository(super.firestore, super.collectionName);
}
