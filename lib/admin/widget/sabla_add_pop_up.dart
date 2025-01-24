import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

class SablaAddPopUp extends StatefulWidget {

  const SablaAddPopUp({super.key});

  @override
  State<SablaAddPopUp> createState() => _SablaAddPopUpState();
}

class _SablaAddPopUpState extends State<SablaAddPopUp> {

  late TextEditingController textController;
  late TextEditingController linkController;

  String? collectionPath;
  String? newImagePath; // New image path if the user selects a new image
  bool isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    HomeCubit.get(context).featchAdSablaPopUpData();


  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is uploadAdPopUpSucces || state is updateAdPopUpSucces|| state is deleteAdPopUpSucces) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت العملية بنجاح!')),
          );
         // HomeCubit.get(context).featchAdPopUpData();
          textController.clear();
          linkController.clear();

          newImagePath = null;
          Navigator.pop(context); // Go back after successful operation
        } else if (state is uploadAdPopUpError || state is updateAdPopUpError|| state is deleteAdPopUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ!')),
          );
          setState(() {
            isButtonDisabled = false;
          });
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        textController = TextEditingController(text: cubit.adSablaPopUpData?.text);
        linkController = TextEditingController(text: cubit.adSablaPopUpData?.link);

        return Scaffold(
          appBar: buildAppBar(context, title: 'اعلان السبله', showBackButton: true),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Text Input
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'النص',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Link Input
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        labelText: 'الرابط',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Picker
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
                            : cubit.adSablaPopUpData != null
                            ? Image.network(
                          cubit.adSablaPopUpData?.imageUrl ?? '',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        )
                            : const Center(
                          child: Text('اختر صورة للإعلان', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        state is updateAdPopUpLoading ||
                            isButtonDisabled ||
                            state is uploadAdPopUpLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () {
                            if (textController.text.isEmpty || linkController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('من فضلك املأ جميع الحقول')),
                              );
                              return;
                            }

                            setState(() {
                              isButtonDisabled = true;
                            });

                            if (cubit.adSablaPopUpData == null) {
                              // Create
                              cubit.uploadSablaAdPopUp(
                                text: textController.text,
                                link: linkController.text,
                                imagePath: newImagePath,
                              );
                            } else {
                              // Update
                              cubit.updateSablaAdPopUp(
                                text: textController.text,
                                link: linkController.text,
                                newImagePath: newImagePath,
                                oldImageUrl: cubit.adSablaPopUpData?.imageUrl ?? '',
                              );
                            }
                          },
                          child: Text(
                            cubit.adSablaPopUpData == null ? 'اضافه' : 'تحديث',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),

                        // Delete Button (Only if Ad Exists)
                        if (cubit.adSablaPopUpData != null)
                          isButtonDisabled || state is deleteAdPopUpLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                isButtonDisabled = true;
                              });
                              cubit.deleteSablaAdPopUp(imageUrl: cubit.adSablaPopUpData?.imageUrl ?? '');
                            },
                            child: const Text('حذف', style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
