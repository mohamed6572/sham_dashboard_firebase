import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/core/utils/app_images.dart';
import 'package:sham/core/widgets/drawer_widget.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';
import 'package:sham/modules/ads/ads.dart';
import 'package:sham/modules/home/home.dart';
import 'package:sham/modules/magazen/magazen.dart';
import 'package:sham/modules/malab/malab.dart';
import 'package:sham/modules/policy/policy.dart';
import 'package:sham/modules/sabla/sabla.dart';
import 'package:sham/modules/shop/shop.dart';
import 'package:sham/modules/who_are/who_are.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/consttant/const.dart';
import '../core/widgets/custom_ad_pop_up.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showAdPopup());
  }




  Future<void> _showAdPopup() async {
    final adData = await HomeCubit.get(context).featchAdPopUpData(); // Replace with your document ID
    if (adData != null) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing without interaction
        builder: (_) => CustomAdPopup(adPopUpModel: adData,

        ),
      );
    }
  }
  int CurrentIndedx = 0;
  List<String> titles = [
    'الرئيسية',
    'السبلة',
    'الملعب',
    'السوق',
    'المجلة',
  ];
  List<Widget>Screens = [
Home(),
    Sabla(),
    Malab(),
    Shop(),
    Magazen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: titles[CurrentIndedx], showBackButton: false),
      drawer: DrawerWidget(
        callbackAction: () {
          setState(() {
            CurrentIndedx = 0;
           // showInterstitialAd();
          });
        },
      ),

      body:Column(
        children: [
          Expanded(child:  Screens[CurrentIndedx]),
          Container(
            padding: EdgeInsets.symmetric(horizontal:25),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               InkWell(
                 onTap: (){
                   setState(() {
                     CurrentIndedx = 1;
                    // showInterstitialAd();
                   });
                 },
                 child:  Text('السبلة',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: CurrentIndedx == 1?Colors.black:Colors.grey),),
               ),
               InkWell(
                 onTap: (){
                   setState(() {
                     CurrentIndedx = 2;
                   //  showInterstitialAd();
                   });
                 },
                 child:  Text('الملعب',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: CurrentIndedx == 2?Colors.black:Colors.grey),),
               ),
               InkWell(
                 onTap: (){
                   setState(() {
                     CurrentIndedx = 3;
                    // showInterstitialAd();
                   });
                 },
                 child:  Text('السوق',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: CurrentIndedx == 3?Colors.black:Colors.grey),),
               ),
               InkWell(
                 onTap: (){
                   setState(() {
                     CurrentIndedx = 4;
                    // showInterstitialAd();
                   });
                 },
                 child:  Text('المجلة',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: CurrentIndedx == 4?Colors.black:Colors.grey),),
               ),

              ],
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () async {
            _contactViaWhatsApp(context);
          },
          backgroundColor: Colors.green,
          tooltip: 'Increment',

          child:  Image.asset(

            Assets.imagesWhatsapIcon,
            height: 30,
            color: Colors.white,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _contactViaWhatsApp(context) async {
    String whatsAppUrl = "";

    String phoneNumber = '96895516675';
    String description = "your-custom-message";

    if (Platform.isIOS) {
      whatsAppUrl =
      'whatsapp://wa.me/$phoneNumber/?text=${Uri.parse(description)}';
    } else {
      whatsAppUrl =
      'https://wa.me/+$phoneNumber?text=${Uri.parse(description)}';
    }


      await launchUrl(
        Uri.parse(whatsAppUrl),
        mode: LaunchMode.externalApplication,
      );
    // } else {
    //   final snackBar = SnackBar(
    //     content: Text("Install WhatsApp First Please"),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }


}
//
// <uses-permission android:name="android.permission.INTERNET" />
// <uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
//
// <queries>
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <data android:scheme="https" />
// </intent>
// <intent>
// <action android:name="android.intent.action.DIAL" />
// <data android:scheme="tel" />
// </intent>
// <intent>
// <action android:name="android.intent.action.SEND" />
// <data android:mimeType="*/*" />
// </intent>
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <data android:scheme="sms" />
// </intent>
// <!-- If your app checks for call support -->
//
// </queries>


// <meta-data
// android:name="com.google.android.gms.ads.APPLICATION_ID"
// android:value="ca-app-pub-5247717174476440~3888138574"/>