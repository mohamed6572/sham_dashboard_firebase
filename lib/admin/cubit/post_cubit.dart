import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sham/admin/cubit/post_state.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/services/storage_service.dart';

import '../../core/services/firestore_service.dart';




class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  static PostCubit get(context) => BlocProvider.of<PostCubit>(context);


  final FirestoreService firestoreService = FirestoreService();
  final StorageService storageService = StorageService();

  /// Method to upload an image and get the download URL
  Future<String?> uploadImage(String filePath) async {
    try {
      print('uploadImage');
      emit(UploadImageLoading()); // Emit loading state for image upload
      final downloadUrl = await storageService.uploadFile(
        filePath: filePath,
        destination: '$StoragePostPath/${DateTime.now().millisecondsSinceEpoch}.jpg',
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

  /// Method to create and add a post with Firestore-generated document ID
  void createPost({
    required String title,
    required String collectionPath,
    required String description,
    required String imagePath, // Local image file path
     String? postUrl,
  }) async {
    print('createPost');
    emit(CreatePostLoading());

    try {
      // Validate post data
      if (title.isEmpty || description.isEmpty || imagePath.isEmpty) {
        emit(CreatePostFailure('Please fill in all fields'));
        return;
      }
print('createPost 2');
      // Step 1: Upload the image and get the download URL
      final imageUrl = await uploadImage(imagePath);
      if (imageUrl == null) {
        emit(CreatePostFailure('Failed to upload image.'));
        return;
      }
print('createPost 3');
      // Step 2: Create a new post model with the uploaded image URL
      final post = PostModel(
        title: title,
        discription: description,
        uid: '', // Empty UID for now
        image: imageUrl, // Use the uploaded image URL
        dateTime:  Timestamp.now(),
        url: postUrl,
      );
print('createPost 4');
      // Step 3: Prepare data for Firestore
      final postData = post.toJson();
      print('postData: $postData');

      // Step 4: Create post in Firestore without the UID
      final postId = await firestoreService.addDocument(
        collectionPath: collectionPath,
        data: postData,
      );

      if (postId != null) {
        // Step 5: Update the document with the UID (postId)
        final success = await firestoreService.updateDocument(
          collectionPath: collectionPath,
          documentId: postId,
          data: {'uid': postId},
        );
        print('success: $success');
        if (success) {
          emit(CreatePostSuccess());
        } else {
          emit(CreatePostFailure('Failed to update post with UID.'));
        }
      } else {
        emit(CreatePostFailure('Failed to add post to Firestore.'));
      }
    } catch (e) {
      emit(CreatePostFailure('Failed to create post: $e'));
    }
  }
  final ImagePicker _imagePicker = ImagePicker();
  String? selectedImagePath;

  /// Function to select an image from the phone
  Future<void> selectImage() async {
    try {
      emit(SelectImageLoading()); // Emit loading state for image selection
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery, // You can use ImageSource.camera for camera
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        selectedImagePath = pickedFile.path;
        emit(SelectImageSuccess(selectedImagePath!)); // Emit success with file path
      } else {
        emit(SelectImageFailure('No image selected.'));
      }
    } catch (e) {
      emit(SelectImageFailure('Error selecting image: $e'));
    }
  }
  /// Method to update an existing post
  void updatePost({
    required String postId,
    required String title,
    required String description,
    required String imagePath, // Can be a URL or local file path
    required String collectionPath,
    String? postUrl,
    required bool isNewImage, // Whether the image has been changed
  }) async {
    emit(UpdatePostLoading());

    try {
      String imageUrl = imagePath;

      // If a new image is selected, upload it
      if (isNewImage) {
        final uploadedImageUrl = await uploadImage(imagePath);
        if (uploadedImageUrl == null) {
          emit(UpdatePostFailure('Failed to upload image.'));
          return;
        }
        imageUrl = uploadedImageUrl;
      }

      // Update the post data
      final updatedPost = {
        'title': title,
        'discription': description,
        'image': imageUrl,
        'url': postUrl,
      };

      final success = await firestoreService.updateDocument(
        collectionPath: collectionPath,
        documentId: postId,
        data: updatedPost,
      );

      if (success) {
        emit(UpdatePostSuccess());
      } else {
        emit(UpdatePostFailure('Failed to update the post.'));
      }
    } catch (e) {
      emit(UpdatePostFailure('Error updating post: $e'));
    }
  }
}

 //"package_name": "com.sham.sahamapp"