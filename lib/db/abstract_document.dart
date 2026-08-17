typedef DocID = String;

abstract class AbstractDocument {
  DocID? get id;

  Map<String, dynamic> toFirestoreDocument();
}

typedef FromFirestore<T extends AbstractDocument> =
    T Function(DocID id, Map<String, dynamic> data);
