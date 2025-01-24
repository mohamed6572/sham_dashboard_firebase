import 'package:flutter/material.dart';
import 'package:sham/admin/add_post_screen.dart';
import 'package:sham/core/consttant/const.dart';

AppBar buildAppBar(BuildContext context,
    {required String title, bool showBackButton = false,bool IFcreate = false}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: primaryColor,
    actions: [
      if(IFcreate)
      IconButton(
        icon: Icon(Icons.add,color: Colors.white,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostScreen()));
        },
      ),
    ],
    leading: showBackButton
        ? IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : null,
    title: Text(title,style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
  );
}
