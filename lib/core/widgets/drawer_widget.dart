import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../modules/ads/ads.dart';
import '../../modules/policy/policy.dart';
import '../../modules/who_are/who_are.dart';
import '../consttant/const.dart';

class DrawerWidget extends StatefulWidget {
   DrawerWidget({super.key, this.callbackAction});
final  Function? callbackAction;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
          )
      ),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.5,
      width: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          drawer_widget(icon: Icons.home_outlined, text: 'الرئيسية', function: widget.callbackAction!
          ), drawer_widget(icon: Icons.group, text: 'من نحن', function: (){
            Navigator.push(context, MaterialPageRoute(builder:(context) => Who_are(),));
          }),
          drawer_widget(icon: Icons.sticky_note_2_outlined, text: 'شروط الاعلانات', function: (){
            Navigator.push(context, MaterialPageRoute(builder:(context) => ads(),));

          }),
          drawer_widget(icon: Icons.sms_outlined, text: 'سياسة الخصوصية', function: (){
            Navigator.push(context, MaterialPageRoute(builder:(context) => Policy(),));
            setState(() {
             // showInterstitialAd1();
            });
          }),
          drawer_widget(icon: Icons.share, text: 'مشاركة التطبيق', function: () async{
            await Share.share("https://play.google.com/store/apps/details?id=com.shamclub",  );
            // setState(() {
            //   showInterstitialAd();
            // });
          },),
          drawer_widget(icon: Icons.logout_outlined, text: 'خروج', function: (){
            SystemNavigator.pop();
          }),
        ],
      ),
    );
  }
  Widget drawer_widget(
      {
        required icon,
        required text,
        required function,

      }
      ) =>
      InkWell(
        onTap:
        function
        ,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 14),
          child:  Row(
            children: [
              Icon(
                icon,
                color:  primaryColor,
              ),
              SizedBox(width: 5,),
              Text(text,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  primaryColor,
                  fontSize: 18


              ),)
            ],
          ),
        ),
      );
}
