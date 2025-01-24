import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  Future<String?> uploadFile({
    required String filePath,
    required String destination,
  }) async {
    try {
      File file = File(filePath);
      final ref = _firebaseStorage.ref(destination);
      final uploadTask = await ref.putFile(file);
      // Get the download URL after uploading
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  /// Download a file from Firebase Storage
  Future<File?> downloadFile({
    required String destination,
    required String localPath,
  }) async {
    try {
      final ref = _firebaseStorage.ref(destination);
      final File localFile = File(localPath);
      await ref.writeToFile(localFile);
      return localFile;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String destination) async {

    try {
      final ref = _firebaseStorage.ref(destination);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
  String getFileNameFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      String fullPath = uri.path; // This gives you the full path, e.g., "/v0/b/myapp.appspot.com/o/uploads%2Fimages%2Ffile.jpg"
      String decodedPath = Uri.decodeComponent(fullPath); // Decodes %2F into "/"
      List<String> segments = decodedPath.split('/'); // Split by "/"
      return segments.last; // Get the last part, which is the file name
    } catch (e) {
      print('Error extracting file name: $e');
      return ''; // Return an empty string if something goes wrong
    }
  }

}