import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a document to a collection
  Future<String?> addDocument({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async
  {
    try {
      DocumentReference docRef =
      await _firestore.collection(collectionPath).add(data);
      return docRef.id; // Return the generated document ID
    } on FirebaseException catch (e) {
      print("Firestore Error (addDocument): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (addDocument): $e");
      return null;
    }
  }
  Future<bool> addDocumentWithId({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).set(data);
      return true;
    } on FirebaseException catch (e) {
      print("Firestore Error (addDocumentWithId): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (addDocumentWithId): $e");
      return false;
    }
  }
  /// Get a document by ID
  Future<Map<String, dynamic>?> getDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      DocumentSnapshot docSnapshot =
      await _firestore.collection(collectionPath).doc(documentId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        print("Document not found: $documentId");
        return null;
      }
    } on FirebaseException catch (e) {
      print("Firestore Error (getDocument): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (getDocument): $e");
      return null;
    }
  }

  /// Update a document
  Future<bool> updateDocument({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
      return true;
    } on FirebaseException catch (e) {
      print("Firestore Error (updateDocument): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (updateDocument): $e");
      return false;
    }
  }

  /// Delete a document
  Future<bool> deleteDocument({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
      return true;
    } on FirebaseException catch (e) {
      print("Firestore Error (deleteDocument): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (deleteDocument): $e");
      return false;
    }
  }

  /// Get all documents in a collection
  Future<List<Map<String, dynamic>>?> getAllDocuments({
    required String collectionPath,
  }) async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } on FirebaseException catch (e) {
      print("Firestore Error (getAllDocuments): ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error (getAllDocuments): $e");
      return null;
    }
  }

  /// Listen to real-time updates in a collection
  Stream<List<Map<String, dynamic>>> streamCollection({
    required String collectionPath,
  }) {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  /// Listen to real-time updates for a specific document
  Stream<Map<String, dynamic>?> streamDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _firestore
        .collection(collectionPath)
        .doc(documentId)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }
  Future<bool> checkUserExists({required String email}) async {
    try {
      // Query the Firestore collection to check if a user with the given email exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // If a document exists, the user exists
      return querySnapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      print("Firestore Error (checkUserExists): ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected Error (checkUserExists): $e");
      return false;
    }
  }

}