import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Layout/cubit/home_cubit.dart';
import '../../core/consttant/const.dart';
import '../../core/widgets/post_view_widget.dart';


class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeCubit.get(context).fetchPosts(collectionName: 'souq');
  }


  @override
  Widget build(BuildContext context) {
  var cubit = HomeCubit.get(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(child:
        AnimationLimiter(
          child: ListView.builder(
            itemCount: cubit.souqPosts.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: PostViewWidget(
                      postModel: cubit.souqPosts[index],
                    ),
                  ),
                ), //
              );
            },
          ),
        ),

            onRefresh: () async {
              HomeCubit.get(context).fetchPosts(collectionName: 'souq');


            });
      },
    );
  }
}

