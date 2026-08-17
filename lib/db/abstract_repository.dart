import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loggy/loggy.dart';

import 'abstract_document.dart';

abstract class AbstractRepository<T extends AbstractDocument> with UiLoggy {
  AbstractRepository(this._firestore, this._collectionName);

  final FirebaseFirestore _firestore;
  final String _collectionName;

  String get collectionName => _collectionName;

  T fromFirestore(DocID id, Map<String, dynamic> data);

  WriteBatch generateBatch() => _firestore.batch();

  DocID generateID() => _firestore.collection(_collectionName).doc().id;

  Future<DocID> writeDocument(
    T document, {
    String? customPath,
    WriteBatch? batch,
  }) async {
    final path = customPath != null
        ? '$customPath/$collectionName'
        : collectionName;
    loggy.debug('About to write document to $path');
    final docId = generateID();

    final docRef = collectionRef(path).doc(docId);
    batch != null ? batch.set(docRef, document) : await docRef.set(document);
    loggy.debug('Successfully written $T with ID $docId');
    return docId;
  }

  Future<T?> fetchDocument(DocID docId) async {
    final docRef = collectionRef(_collectionName).doc(docId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      loggy.warning('ID of $docId not found in $_collectionName');
      return null;
    }
    loggy.debug('fetch was successful');
    return snapshot.data();
  }

  CollectionReference<T> collectionRef([String? customPath]) {
    final path = customPath ?? _collectionName;
    return _firestore
        .collection(path)
        .withConverter<T>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data() ?? {};
            return fromFirestore(snapshot.id, data);
          },
          toFirestore: (document, _) {
            final map = document.toFirestoreDocument();
            map.remove('id'); // ID is stored as doc path, not in body
            return map;
          },
        );
  }
}
