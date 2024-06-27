import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class for interacting with Firestore.
/// Provides methods to perform CRUD operations and queries on Firestore collections and documents.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Retrieves a document from the specified collection by its ID.
  /// Returns a [DocumentSnapshot] containing the document data if the retrieval is successful.
  /// Parameters:
  /// - `collection`: The name of the collection containing the document.
  /// - `docId`: The ID of the document to retrieve.
  Future<DocumentSnapshot> getDocumentById(String collection, String docId) async {
    DocumentSnapshot snapshot = await _db.collection(collection).doc(docId).get();
    return snapshot;
  }

  /// Retrieves all documents from the specified collection.
  /// Returns a [QuerySnapshot] containing the documents if the retrieval is successful.
  /// Parameters:
  /// - `collectionPath`: The path of the collection to retrieve documents from.
  Future<QuerySnapshot> getCollection(String collectionPath) async {
    try {
      return await _db.collection(collectionPath).get();
    } catch (e) {
      rethrow;
    }
  }

  /// Adds a new document to the specified collection with the provided data.
  /// Parameters:
  /// - `collection`: The name of the collection to add the document to.
  /// - `data`: A map containing the data for the new document.
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  /// Updates an existing document in the specified collection with the provided data.
  /// Parameters:
  /// - `collection`: The name of the collection containing the document.
  /// - `docId`: The ID of the document to update.
  /// - `data`: A map containing the updated data for the document.
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  /// Deletes a document from the specified collection by its ID.
  /// Parameters:
  /// - `collection`: The name of the collection containing the document.
  /// - `docId`: The ID of the document to delete.
  Future<void> deleteDocument(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }

  /// Queries a collection with the specified field, value, and operator.
  /// Returns a [QuerySnapshot] containing the documents that match the query.
  /// Parameters:
  /// - `collectionPath`: The path of the collection to query.
  /// - `field`: The field to query.
  /// - `value`: The value to compare the field against.
  /// - `operator`: The comparison operator to use (e.g., '==', '>', '<=', 'array-contains').
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
