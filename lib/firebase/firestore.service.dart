import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getDocumentById(String collection, String docId) async {
    DocumentSnapshot snapshot = await _db.collection(collection).doc(docId).get();
    return snapshot;
  }

  Future<QuerySnapshot> getCollection(String collectionPath) async {
    try {
      return await _db.collection(collectionPath).get();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  Future<QuerySnapshot> queryCollection({
    required String collectionPath,
    required String field,
    required dynamic value,
    required String operator,
  }) async {
    try {
      Query query = _db.collection(collectionPath);

      switch (operator) {
        case '==':
          query = query.where(field, isEqualTo: value);
          break;
        case '!=':
          query = query.where(field, isNotEqualTo: value);
          break;
        case '>':
          query = query.where(field, isGreaterThan: value);
          break;
        case '>=':
          query = query.where(field, isGreaterThanOrEqualTo: value);
          break;
        case '<':
          query = query.where(field, isLessThan: value);
          break;
        case '<=':
          query = query.where(field, isLessThanOrEqualTo: value);
          break;
        case 'array-contains':
          query = query.where(field, arrayContains: value);
          break;
        case 'array-contains-any':
          query = query.where(field, arrayContainsAny: value);
          break;
        case 'in':
          query = query.where(field, whereIn: value);
          break;
        case 'not-in':
          query = query.where(field, whereNotIn: value);
          break;
        default:
          throw ArgumentError('Invalid operator: $operator');
      }

      return await query.get();
    } catch (e) {
      rethrow;
    }
  }
}
