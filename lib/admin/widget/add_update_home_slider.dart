import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sham/admin/cubit/post_cubit.dart';
import 'package:sham/admin/cubit/post_state.dart';

class AddUpdateSliderScreen extends StatefulWidget {
  final String? sliderId; // If `null`, it's an "add" operation; otherwise, it's "update"
  final String? currentImageUrl;
  final String? currentText;
  final String? currentLink;

  AddUpdateSliderScreen({
    this.sliderId,
    this.currentImageUrl,
    this.currentText,
    this.currentLink,
  });

  @override
  State<AddUpdateSliderScreen> createState() => _AddUpdateSliderScreenState();
}

class _AddUpdateSliderScreenState extends State<AddUpdateSliderScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // If updating, pre-fill fields with current slider data
    if (widget.sliderId != null) {
      _textController.text = widget.currentText ?? '';
      _linkController.text = widget.currentLink ?? '';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PostCubit.get(context);

    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is UploadSliderSuccess || state is UpdatePostSuccess) {
          PostCubit.get(context).fetchHomeSliderData();
          Navigator.pop(context); // Return to the previous screen
        } else if (state is UploadSliderFailure) {
          PostCubit.get(context).fetchHomeSliderData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.sliderId == null ? 'إضافة صورة جديدة' : 'تحديث الصورة'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Image picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage != null
                        ? Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
                        : widget.currentImageUrl != null
                        ? Image.network(widget.currentImageUrl!, height: 200, fit: BoxFit.cover)
                        : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.add_a_photo, size: 50),
                    ),
                  ),
                  const SizedBox(height: 20),
              
                  // Text field for slider text
                  // TextField(
                  //   controller: _textController,
                  //   decoration: InputDecoration(
                  //     labelText: 'النص',
                  //     border: OutlineInputBorder(),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
              
                  // Text field for slider link
                  TextField(
                    controller: _linkController,
                    decoration: InputDecoration(
                      labelText: 'الرابط',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
              
                  // Submit button
                  ElevatedButton(
                    onPressed: () async {
                    //  final text = _textController.text.trim();
                      final link = _linkController.text.trim();
              
                      if (widget.sliderId == null) {
                        // Add new slider
                        await cubit.uploadSlider(
                          imagePath: _selectedImage?.path ?? '',
                          link: link,
                          text: '',
                        );
                      } else {
                        // Update existing slider
                        await cubit.updateSlider(
                          sliderId: widget.sliderId!,
                          link: link,
                          text: '',
                          currentImageUrl: widget.currentImageUrl!,
                          collectionPath: 'adHome',
                          isNewImage: _selectedImage != null,
                          newImagePath: _selectedImage?.path,
                        );
                      }
                    },
                    child: state is UploadSliderLoading || state is UpdatePostLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(widget.sliderId == null ? 'إضافة' : 'تحديث'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
