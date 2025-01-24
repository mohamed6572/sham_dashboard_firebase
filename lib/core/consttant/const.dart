import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/utils/app_images.dart';

String bannerIDD = 'ca-app-pub-5247717174476440/1159045216'; //'ca-app-pub-7933344131979525/1741544890';//real
String testIMageUrl = 'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png';
String StoragePostPath = 'posts';
String StorageAddPath = 'ads';
const Color primaryColor = Colors.indigoAccent;
String formatDateTime(Timestamp timestamp) {
String time =   DateFormat('yyyy-MM-dd -- hh:mm a')
      .format(DateTime.parse(timestamp.toDate().toString()));
  return time;
}