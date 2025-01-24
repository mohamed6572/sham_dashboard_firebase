import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/utils/app_images.dart';
import 'package:sham/modules/image_preview_screen/image_preview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PostViewDetailsWidget extends StatelessWidget {
  const PostViewDetailsWidget({super.key, required this.postModel});
  final PostModel postModel;
///take the model from here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePreviewScreen(imagePath: testIMageUrl)));
            //   },
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(20),
            //       bottomRight: Radius.circular(20),
            //     ),
            //     child: Image.asset(Assets.imagesAppIcon,
            //
            //       height: 220,
            //       width: double.infinity,
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                ///path the image link
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ImagePreviewScreen(imagePath: postModel.image)));
              },
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.indigoAccent,
                      width: 2,
                    ),
                  ),
                ),
                child: Image.network(
                  postModel.image,
                  height: 220,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    postModel.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    postModel.discription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async{
                  if(postModel.url != null) {
                await launchUrl(
                  Uri.parse(postModel.url??''),
                  mode: LaunchMode.externalApplication,
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لا يوجد رابط للتصفح',textAlign: TextAlign.center,),
                  ),
                );}

            },
            child: const Text(
              'تصفح',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
            ),
          ),
        ),
      ),
    );
  }
}
