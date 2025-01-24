import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdPopUpModel{
  final String imageUrl;
  final String text;
  final String link;

  AdPopUpModel({
    required this.imageUrl,
    required this.text,
    required this.link,
  });

  void launchURL(BuildContext context) async {
    if (await launchUrl(Uri.parse(link))) {
      await launch(link);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the link')),
      );
    }
  }

  factory AdPopUpModel.fromJson(Map<String, dynamic> json) {
    return AdPopUpModel(
      imageUrl: json['imageUrl'],
      text: json['text'],
      link: json['link'],
    );
  }
  toJson() {
    return {
      'imageUrl': imageUrl,
      'text': text,
      'link': link,
    };
  }
}