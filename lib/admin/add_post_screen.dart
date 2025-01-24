import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/widgets/chose_collection.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

import 'cubit/post_cubit.dart';
import 'cubit/post_state.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  String? collectionPath;
  bool isButtonDisabled = false;  // Variable to disable the button while loading

  /// Store the selected collection
  void _handleCollectionSelection(String? type) {
    setState(() {
      collectionPath = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PostCubit.get(context);

    return Scaffold(
      appBar: buildAppBar(context, title: 'اضافه', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is CreatePostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Post created successfully!')),
              );
              // Clear the form after success
              titleController.clear();
              descriptionController.clear();
              urlController.clear();
              cubit.selectedImagePath = null;
              setState(() {
                isButtonDisabled = false;  // Enable button after success
              });
            } else if (state is CreatePostFailure || state is UploadImageFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text((state as dynamic).error)),
              );
              setState(() {
                isButtonDisabled = false;  // Enable button after failure
              });
            }
          },
          builder: (context, state) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Collection Dropdown
                    ChoseCollectionDropdown(
                      onTypeSelected: _handleCollectionSelection,
                    ),
                    SizedBox(height: 16),

                    // Title Input
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'العنون',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Description Input
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Optional URL Input
                    TextField(
                      controller: urlController,
                      decoration: InputDecoration(
                        labelText: 'الرابط (اختياري)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Image Picker and Display
                    InkWell(
                      onTap: () => cubit.selectImage(),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: cubit.selectedImagePath != null
                            ? Image.file(
                          File(cubit.selectedImagePath!),
                          fit: BoxFit.cover,
                        )
                            : Center(
                          child: Text(
                            'اضغط لاختيار صورة',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Submit Button
                    state is CreatePostLoading || isButtonDisabled
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(primaryColor),
                      ),
                      onPressed: () async {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty ||
                            cubit.selectedImagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('من فضلك املأ جميع الحقول')),
                          );
                          return;
                        }

                        setState(() {
                          isButtonDisabled = true;  // Disable the button while creating the post
                        });

                        // Upload image and create post
                        final title = titleController.text;
                        final description = descriptionController.text;
                        final url = urlController.text.isEmpty ? null : urlController.text;

                        if (cubit.selectedImagePath != null) {
                          cubit.createPost(
                            title: title,
                            description: description,
                            imagePath: cubit.selectedImagePath!,
                            postUrl: url,
                            collectionPath: collectionPath ?? "",
                          );
                        }
                      },
                      child: Text('اضافه',style: TextStyle(color: Colors.white),),
                    ),

                    if (state is CreatePostFailure)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}