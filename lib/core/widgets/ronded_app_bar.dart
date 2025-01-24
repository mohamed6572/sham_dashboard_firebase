import 'package:flutter/material.dart';
import 'package:sham/admin/add_post_screen.dart';
import 'package:sham/core/consttant/const.dart';

import '../../admin/cubit/post_cubit.dart';

AppBar buildAppBar(BuildContext context,
    {required String title, bool showBackButton = false,bool IFcreate = false,bool IfRefresh = false}) {
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
      if(IfRefresh)
        IconButton(
          icon: Icon(Icons.refresh,color: Colors.white,),
          onPressed: () {
            PostCubit.get(context).fetchHomeSliderData();
          },
        ),

    ],
    leading: showBackButton
        ? BackButton(
            color: Colors.white,
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
