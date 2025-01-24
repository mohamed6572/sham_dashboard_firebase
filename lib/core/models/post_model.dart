import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String title;
  final String discription;
  final String image;
  final String uid;
  final Timestamp dateTime;
  final String? url;

  PostModel({
    required this.title,
    required this.discription,
    required this.uid,
    required this.image,
    required this.dateTime,
    this.url,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title']??'',
      discription: json['discription']??'',
      uid: json['uid']??'',
      image: json['image']??'',
      dateTime: json['dateTime']??DateTime.now(),
      url: json['url']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'discription': discription,
      'image': image,
      'uid': uid,
      'dateTime': dateTime,
      'url': url,
    };
  }


}