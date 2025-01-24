import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:sham/core/models/ad_pop_up_model.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/services/firestore_service.dart';
import 'package:sham/core/services/storage_service.dart';

import '../../core/consttant/const.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  // ['sabla', 'malab', 'souq']

  FirestoreService _firestoreService = FirestoreService();
  StorageService _storageService = StorageService();

  List<PostModel> sablaPosts = [];
  List<PostModel> malabPosts = [];
  List<PostModel> souqPosts = [];

  AdPopUpModel? adPopUpData;
  AdPopUpModel? adSablaPopUpData;
  AdPopUpModel? adMalabPopUpData;
  AdPopUpModel? adSouqPopUpData;
  AdPopUpModel? adMagazenPopUpData;

  /// Method to upload an image and get the download URL
  Future<String?> uploadImage(String filePath) async {
    try {
      print('uploadImage');
      emit(UploadImageLoading()); // Emit loading state for image upload
      final downloadUrl = await _storageService.uploadFile(
        filePath: filePath,
        destination:
            '$StorageAddPath/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      print('downloadUrl: $downloadUrl');
      if (downloadUrl != null) {
        emit(UploadImageSuccess(downloadUrl)); // Emit success with download URL
        return downloadUrl;
      } else {
        emit(UploadImageFailure('Failed to upload image.'));
        return null;
      }
    } catch (e) {
      emit(UploadImageFailure('Error uploading image: $e'));
      return null;
    }
  }

  Future<AdPopUpModel?> featchAdPopUpData() async {
    emit(loadAddPopUpLoading());
    try {
      var data = await _firestoreService.getDocument(
          collectionPath: 'adPopUp', documentId: 'home');

      AdPopUpModel adPopUpModel = AdPopUpModel.fromJson(data!);
      adPopUpData = adPopUpModel;
      emit(loadAddPopUpSucces());

      return adPopUpModel;
    } catch (e) {
      emit(loadAddPopUpError());
      return null;
    }
  }

  Future<AdPopUpModel?> featchAdSablaPopUpData() async {
    emit(loadAddPopUpLoading());
    try {
      var data = await _firestoreService.getDocument(
          collectionPath: 'adPopUp_sabla', documentId: 'home');

      AdPopUpModel adPopUpModel = AdPopUpModel.fromJson(data!);
      adSablaPopUpData = adPopUpModel;
      emit(loadAddPopUpSucces());

      return adPopUpModel;
    } catch (e) {
      emit(loadAddPopUpError());
      return null;
    }
  }

  Future<AdPopUpModel?> featchAdMalabPopUpData() async {
    emit(loadAddPopUpLoading());
    try {
      var data = await _firestoreService.getDocument(
          collectionPath: 'adPopUp_malab', documentId: 'home');

      AdPopUpModel adPopUpModel = AdPopUpModel.fromJson(data!);
      adMalabPopUpData = adPopUpModel;
      emit(loadAddPopUpSucces());

      return adPopUpModel;
    } catch (e) {
      emit(loadAddPopUpError());
      return null;
    }
  }

  Future<AdPopUpModel?> featchAdSouqPopUpData() async {
    emit(loadAddPopUpLoading());
    try {
      var data = await _firestoreService.getDocument(
          collectionPath: 'adPopUp_souq', documentId: 'home');

      AdPopUpModel adPopUpModel = AdPopUpModel.fromJson(data!);
      adSouqPopUpData = adPopUpModel;
      emit(loadAddPopUpSucces());

      return adPopUpModel;
    } catch (e) {
      emit(loadAddPopUpError());
      return null;
    }
  }

  Future<AdPopUpModel?> featchAdMagazenPopUpData() async {
    emit(loadAddPopUpLoading());
    try {
      var data = await _firestoreService.getDocument(
          collectionPath: 'adPopUp_magazen', documentId: 'home');

      AdPopUpModel adPopUpModel = AdPopUpModel.fromJson(data!);
      adMagazenPopUpData = adPopUpModel;
      emit(loadAddPopUpSucces());

      return adPopUpModel;
    } catch (e) {
      emit(loadAddPopUpError());
      return null;
    }
  }

  Future<void> fetchPosts({required String collectionName}) async {
    emit(loadPostLoading());
    sablaPosts = [];
    malabPosts = [];
    souqPosts = [];
    try {
      var data = await _firestoreService.getAllDocuments(
          collectionPath: collectionName);
      data!.forEach((element) {
        if (collectionName == 'sabla') {
          sablaPosts.add(PostModel.fromJson(element));
        }
        if (collectionName == 'malab') {
          malabPosts.add(PostModel.fromJson(element));
        }
        if (collectionName == 'souq') {
          souqPosts.add(PostModel.fromJson(element));
        }
      });

      emit(loadPostSucces());
    } catch (e) {
      print('error: $e');
      emit(loadPostError());
    }
  }

  String pdfLink = '';
  Future<void> fetchPdfLink({
    required String collectionPath,
  }) async {
    try {
      emit(loadPDFLoading());

      // Get document from Firestore
      var data = await _firestoreService.getDocument(
        collectionPath: collectionPath,
        documentId: 'pdf_document',
      );

      // If document exists, return the PDF URL
      if (data != null && data.containsKey('pdfName')) {
        pdfLink = data['pdfName'];
        print('PDF link: $pdfLink');
        String pdfName = data.keys.first;
        print('PDF name: $pdfName');
        emit(loadPDFSucces());
      } else {
        emit(loadPDFError());
      }
    } catch (e) {
      emit(loadPDFError());
      print('Error fetching PDF link: $e');
      return null;
    }
  }

  void deletePost(
      {required String collectionPath,
      required String documentId,
      required String imageUrl}) async {
    emit(deletePostLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: collectionPath,
        documentId: documentId,
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('posts/$fileName');
        emit(deletePostSucces());
      } else {
        emit(deletePostError());
      }
    } catch (e) {
      emit(deletePostError());
      print('Error deleting post: $e');
    }
  }

  void deleteAdPopUp({required String imageUrl}) async {
    emit(deleteAdPopUpLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: 'adPopUp',
        documentId: 'home',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('$StorageAddPath/$fileName');
        adPopUpData = null;

        emit(deleteAdPopUpSucces());
      } else {
        emit(deleteAdPopUpError(
            'Failed to delete the ad pop-up. Please try again later.'));
      }
    } catch (e) {
      emit(deleteAdPopUpError(
          'Failed to delete the ad pop-up. Please try again later.'));
      print('Error deleting post: $e');
    }
  }

  void deleteMagazenAdPopUp({required String imageUrl}) async {
    emit(deleteAdPopUpLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: 'adPopUp_magazen',
        documentId: 'home',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('$StorageAddPath/$fileName');
        adPopUpData = null;

        emit(deleteAdPopUpSucces());
      } else {
        emit(deleteAdPopUpError(
            'Failed to delete the ad pop-up. Please try again later.'));
      }
    } catch (e) {
      emit(deleteAdPopUpError(
          'Failed to delete the ad pop-up. Please try again later.'));
      print('Error deleting post: $e');
    }
  }

  void deleteSouqAdPopUp({required String imageUrl}) async {
    emit(deleteAdPopUpLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: 'adPopUp_souq',
        documentId: 'home',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('$StorageAddPath/$fileName');
        adSouqPopUpData = null;

        emit(deleteAdPopUpSucces());
      } else {
        emit(deleteAdPopUpError(
            'Failed to delete the ad pop-up. Please try again later.'));
      }
    } catch (e) {
      emit(deleteAdPopUpError(
          'Failed to delete the ad pop-up. Please try again later.'));
      print('Error deleting post: $e');
    }
  }

  void deleteMalabAdPopUp({required String imageUrl}) async {
    emit(deleteAdPopUpLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: 'adPopUp_malab',
        documentId: 'home',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('$StorageAddPath/$fileName');
        adMalabPopUpData = null;

        emit(deleteAdPopUpSucces());
      } else {
        emit(deleteAdPopUpError(
            'Failed to delete the ad pop-up. Please try again later.'));
      }
    } catch (e) {
      emit(deleteAdPopUpError(
          'Failed to delete the ad pop-up. Please try again later.'));
      print('Error deleting post: $e');
    }
  }

  void deleteSablaAdPopUp({required String imageUrl}) async {
    emit(deleteAdPopUpLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: 'adPopUp_sabla',
        documentId: 'home',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(imageUrl);
        _storageService.deleteFile('$StorageAddPath/$fileName');
        adSablaPopUpData = null;

        emit(deleteAdPopUpSucces());
      } else {
        emit(deleteAdPopUpError(
            'Failed to delete the ad pop-up. Please try again later.'));
      }
    } catch (e) {
      emit(deleteAdPopUpError(
          'Failed to delete the ad pop-up. Please try again later.'));
      print('Error deleting post: $e');
    }
  }

  void deletePdf({
    required String collectionPath,
    required String pdfUrl,
  }) async {
    emit(deletePDFLoading());
    try {
      bool success = await _firestoreService.deleteDocument(
        collectionPath: collectionPath,
        documentId: 'pdf_document',
      );
      if (success) {
        var fileName = await _storageService.getFileNameFromUrl(pdfUrl);
        _storageService.deleteFile('pdf/$fileName');
        pdfLink = '';
        emit(deletePDFSucces());
      } else {
        emit(deletePDFError());
      }
    } catch (e) {
      emit(deletePDFError());
      print('Error deleting post: $e');
    }
  }

  void uploadPdf({
    required String collectionPath,
  }) async {
    emit(uploadPDFLoading());

    try {
      // Step 1: Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Restrict to PDF files only
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        String fileName = filePath.split('/').last;
        String destination = 'pdf/$fileName';

        // Step 2: Upload the PDF file to Firebase Storage
        String? uploadedPdfUrl = await _storageService.uploadFile(
          filePath: filePath,
          destination: destination,
        );

        if (uploadedPdfUrl != null) {
          // Step 3: Update the Firestore document with the PDF link
          Map<String, dynamic> pdfData = {
            'pdfName': uploadedPdfUrl, // Store the PDF link in Firestore
          };

          await _firestoreService.addDocumentWithId(
            collectionPath: collectionPath,
            documentId: 'pdf_document', // Fixed document ID for the PDF
            data: pdfData,
          );

          pdfLink = uploadedPdfUrl;
          emit(uploadPDFSuccess());
        } else {
          emit(uploadPDFError());
          print('Failed to upload the PDF file.');
        }
      } else {
        emit(uploadPDFCancelled());
        print('PDF selection canceled.');
      }
    } catch (e) {
      emit(uploadPDFError());
      print('Error uploading PDF: $e');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();
  String? selectedImagePath;

  /// Function to select an image from the phone
  Future<void> selectImage() async {
    try {
      emit(SelectImageLoading()); // Emit loading state for image selection
      final XFile? pickedFile = await _imagePicker.pickImage(
        source:
            ImageSource.gallery, // You can use ImageSource.camera for camera
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        selectedImagePath = pickedFile.path;
        emit(SelectImageSuccess(
            selectedImagePath!)); // Emit success with file path
      } else {
        emit(SelectImageFailure('No image selected.'));
      }
    } catch (e) {
      emit(SelectImageFailure('Error selecting image: $e'));
    }
  }

  Future<void> uploadAdPopUp({
    required String text,
    required String link,
    String? imagePath,
  }) async {
    emit(uploadAdPopUpLoading());
    try {
      String? imageUrl;

      // Step 1: Upload the image if provided
      if (imagePath != null) {
        imageUrl = await uploadImage(imagePath);
        if (imageUrl == null) {
          emit(uploadAdPopUpError('Failed to upload image.'));
          return;
        }
      }

      // Step 2: Prepare data for Firestore
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl ?? '',
      };

      // Step 3: Upload to Firestore
      await _firestoreService.addDocumentWithId(
        collectionPath: 'adPopUp',
        documentId: 'home',
        data: adData,
      );

      emit(uploadAdPopUpSucces());
    } catch (e) {
      emit(uploadAdPopUpError('Error uploading ad pop-up: $e'));
    }
  }

  Future<void> updateAdPopUp({
    required String text,
    required String link,
    String? newImagePath, // New image file path if changed
    required String oldImageUrl, // Current image URL
  }) async {
    emit(updateAdPopUpLoading());
    try {
      String imageUrl = oldImageUrl;

      // Step 1: Check if a new image is provided
      if (newImagePath != null) {
        imageUrl = await uploadImage(newImagePath) ?? oldImageUrl;
      }

      // Step 2: Prepare data for Firestore update
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl,
      };

      // Step 3: Update Firestore document
      await _firestoreService.updateDocument(
        collectionPath: 'adPopUp',
        documentId: 'home',
        data: adData,
      );

      emit(updateAdPopUpSucces());
    } catch (e) {
      emit(updateAdPopUpError('Error updating ad pop-up: $e'));
    }
  }

  Future<void> uploadMagazenAdPopUp({
    required String text,
    required String link,
    String? imagePath,
  }) async {
    emit(uploadAdPopUpLoading());
    try {
      String? imageUrl;

      // Step 1: Upload the image if provided
      if (imagePath != null) {
        imageUrl = await uploadImage(imagePath);
        if (imageUrl == null) {
          emit(uploadAdPopUpError('Failed to upload image.'));
          return;
        }
      }

      // Step 2: Prepare data for Firestore
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl ?? '',
      };

      // Step 3: Upload to Firestore
      await _firestoreService.addDocumentWithId(
        collectionPath: 'adPopUp_magazen',
        documentId: 'home',
        data: adData,
      );

      emit(uploadAdPopUpSucces());
    } catch (e) {
      emit(uploadAdPopUpError('Error uploading ad pop-up: $e'));
    }
  }

  Future<void> updateMagazenAdPopUp({
    required String text,
    required String link,
    String? newImagePath, // New image file path if changed
    required String oldImageUrl, // Current image URL
  }) async {
    emit(updateAdPopUpLoading());
    try {
      String imageUrl = oldImageUrl;

      // Step 1: Check if a new image is provided
      if (newImagePath != null) {
        imageUrl = await uploadImage(newImagePath) ?? oldImageUrl;
      }

      // Step 2: Prepare data for Firestore update
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl,
      };

      // Step 3: Update Firestore document
      await _firestoreService.updateDocument(
        collectionPath: 'adPopUp_magazen',
        documentId: 'home',
        data: adData,
      );

      emit(updateAdPopUpSucces());
    } catch (e) {
      emit(updateAdPopUpError('Error updating ad pop-up: $e'));
    }
  }

  Future<void> uploadSablaAdPopUp({
    required String text,
    required String link,
    String? imagePath,
  }) async {
    emit(uploadAdPopUpLoading());
    try {
      String? imageUrl;

      // Step 1: Upload the image if provided
      if (imagePath != null) {
        imageUrl = await uploadImage(imagePath);
        if (imageUrl == null) {
          emit(uploadAdPopUpError('Failed to upload image.'));
          return;
        }
      }

      // Step 2: Prepare data for Firestore
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl ?? '',
      };

      // Step 3: Upload to Firestore
      await _firestoreService.addDocumentWithId(
        collectionPath: 'adPopUp_sabla',
        documentId: 'home',
        data: adData,
      );

      emit(uploadAdPopUpSucces());
    } catch (e) {
      emit(uploadAdPopUpError('Error uploading ad pop-up: $e'));
    }
  }

  Future<void> updateSablaAdPopUp({
    required String text,
    required String link,
    String? newImagePath, // New image file path if changed
    required String oldImageUrl, // Current image URL
  }) async {
    emit(updateAdPopUpLoading());
    try {
      String imageUrl = oldImageUrl;

      // Step 1: Check if a new image is provided
      if (newImagePath != null) {
        imageUrl = await uploadImage(newImagePath) ?? oldImageUrl;
      }

      // Step 2: Prepare data for Firestore update
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl,
      };

      // Step 3: Update Firestore document
      await _firestoreService.updateDocument(
        collectionPath: 'adPopUp_sabla',
        documentId: 'home',
        data: adData,
      );

      emit(updateAdPopUpSucces());
    } catch (e) {
      emit(updateAdPopUpError('Error updating ad pop-up: $e'));
    }
  }

  Future<void> uploadMalabAdPopUp({
    required String text,
    required String link,
    String? imagePath,
  }) async {
    emit(uploadAdPopUpLoading());
    try {
      String? imageUrl;

      // Step 1: Upload the image if provided
      if (imagePath != null) {
        imageUrl = await uploadImage(imagePath);
        if (imageUrl == null) {
          emit(uploadAdPopUpError('Failed to upload image.'));
          return;
        }
      }

      // Step 2: Prepare data for Firestore
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl ?? '',
      };

      // Step 3: Upload to Firestore
      await _firestoreService.addDocumentWithId(
        collectionPath: 'adPopUp_malab',
        documentId: 'home',
        data: adData,
      );

      emit(uploadAdPopUpSucces());
    } catch (e) {
      emit(uploadAdPopUpError('Error uploading ad pop-up: $e'));
    }
  }

  Future<void> updateMalabAdPopUp({
    required String text,
    required String link,
    String? newImagePath, // New image file path if changed
    required String oldImageUrl, // Current image URL
  }) async {
    emit(updateAdPopUpLoading());
    try {
      String imageUrl = oldImageUrl;

      // Step 1: Check if a new image is provided
      if (newImagePath != null) {
        imageUrl = await uploadImage(newImagePath) ?? oldImageUrl;
      }

      // Step 2: Prepare data for Firestore update
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl,
      };

      // Step 3: Update Firestore document
      await _firestoreService.updateDocument(
        collectionPath: 'adPopUp_malab',
        documentId: 'home',
        data: adData,
      );

      emit(updateAdPopUpSucces());
    } catch (e) {
      emit(updateAdPopUpError('Error updating ad pop-up: $e'));
    }
  }

  Future<void> uploadSouqAdPopUp({
    required String text,
    required String link,
    String? imagePath,
  }) async {
    emit(uploadAdPopUpLoading());
    try {
      String? imageUrl;

      // Step 1: Upload the image if provided
      if (imagePath != null) {
        imageUrl = await uploadImage(imagePath);
        if (imageUrl == null) {
          emit(uploadAdPopUpError('Failed to upload image.'));
          return;
        }
      }

      // Step 2: Prepare data for Firestore
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl ?? '',
      };

      // Step 3: Upload to Firestore
      await _firestoreService.addDocumentWithId(
        collectionPath: 'adPopUp_souq',
        documentId: 'home',
        data: adData,
      );

      emit(uploadAdPopUpSucces());
    } catch (e) {
      emit(uploadAdPopUpError('Error uploading ad pop-up: $e'));
    }
  }

  Future<void> updateSouqAdPopUp({
    required String text,
    required String link,
    String? newImagePath, // New image file path if changed
    required String oldImageUrl, // Current image URL
  }) async {
    emit(updateAdPopUpLoading());
    try {
      String imageUrl = oldImageUrl;

      // Step 1: Check if a new image is provided
      if (newImagePath != null) {
        imageUrl = await uploadImage(newImagePath) ?? oldImageUrl;
      }

      // Step 2: Prepare data for Firestore update
      Map<String, dynamic> adData = {
        'text': text,
        'link': link,
        'imageUrl': imageUrl,
      };

      // Step 3: Update Firestore document
      await _firestoreService.updateDocument(
        collectionPath: 'adPopUp_souq',
        documentId: 'home',
        data: adData,
      );

      emit(updateAdPopUpSucces());
    } catch (e) {
      emit(updateAdPopUpError('Error updating ad pop-up: $e'));
    }
  }
}
