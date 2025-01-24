import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/widgets/chose_collection.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

import '../cubit/post_cubit.dart';
import '../cubit/post_state.dart';

class UpdatePostScreen extends StatefulWidget {
  final String postId; // Post ID to be updated
  final String initialTitle;
  final String initialDescription;
  final String? initialUrl;
  final String initialImageUrl; // Initial image URL
  final String initialCollectionPath;

  const UpdatePostScreen({
    required this.postId,
    required this.initialTitle,
    required this.initialDescription,
    this.initialUrl,
    required this.initialImageUrl,
    required this.initialCollectionPath,
  });

  @override
  State<UpdatePostScreen> createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController urlController;

  String? collectionPath;
  String? newImagePath; // New image path if the user selects a new image
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    descriptionController = TextEditingController(text: widget.initialDescription);
    urlController = TextEditingController(text: widget.initialUrl ?? '');
    collectionPath = widget.initialCollectionPath;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PostCubit.get(context);

    return Scaffold(
      appBar: buildAppBar(context, title: 'تحديث', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is UpdatePostSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تحديث المنشور بنجاح!')),
              );
              HomeCubit.get(context).fetchPosts(collectionName: collectionPath!);
              newImagePath = null;
              Navigator.pop(context); // Go back after update
            } else if (state is UpdatePostFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              setState(() {
                isButtonDisabled = false;
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

                    SizedBox(height: 16),

                    // Title Input
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'العنوان',
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
                      onTap: () async {
                        await cubit.selectImage();
                        if (cubit.selectedImagePath != null) {
                          setState(() {
                            newImagePath = cubit.selectedImagePath;
                          });
                        }
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: newImagePath != null
                            ? Image.file(
                          File(newImagePath!),
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          widget.initialImageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Submit Button
                    state is UpdatePostLoading || isButtonDisabled
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(primaryColor),
                      ),
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('من فضلك املأ جميع الحقول')),
                          );
                          return;
                        }

                        setState(() {
                          isButtonDisabled = true;
                        });

                        cubit.updatePost(
                          postId: widget.postId,
                          title: titleController.text,
                          description: descriptionController.text,
                          imagePath: newImagePath ?? widget.initialImageUrl,
                          postUrl: urlController.text.isEmpty
                              ? null
                              : urlController.text,
                          collectionPath: collectionPath ?? "",
                          isNewImage: newImagePath != null,
                        );
                      },
                      child: Text('تحديث', style: TextStyle(color: Colors.white)),
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