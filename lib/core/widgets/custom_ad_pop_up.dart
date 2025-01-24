import 'package:flutter/material.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/models/ad_pop_up_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAdPopup extends StatelessWidget {
final AdPopUpModel adPopUpModel;

  const CustomAdPopup({
    required this.adPopUpModel,

    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ad Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(adPopUpModel.imageUrl, fit: BoxFit.cover),
          ),
          // Ad Text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              adPopUpModel.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Open Link Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () =>adPopUpModel.launchURL(context),
              child: const Text('تفاصيل',style: TextStyle(color: Colors.white),),
            ),
          ),
          // Close Button
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}