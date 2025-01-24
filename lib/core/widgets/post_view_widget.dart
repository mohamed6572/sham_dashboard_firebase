import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/widgets/post_view_details_widget.dart';
import 'package:sham/core/utils/app_images.dart';

import '../consttant/const.dart';

class PostViewWidget extends StatelessWidget {
  const PostViewWidget({super.key, required this.postModel});
  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///path the model here
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PostViewDetailsWidget(postModel: postModel)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(12),
        height: 350,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                postModel.image,
                height: 220,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${postModel.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${formatDateTime(postModel.dateTime)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
