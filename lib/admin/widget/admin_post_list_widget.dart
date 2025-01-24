import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/admin/widget/update_post_screnn.dart';
import 'package:sham/core/models/post_model.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

class AdminPostListWidget extends StatefulWidget {
  const AdminPostListWidget({super.key, required this.collectionName, required this.title});
  final String collectionName;
  final String title;

  @override
  State<AdminPostListWidget> createState() => _AdminPostListWidgetState();
}

class _AdminPostListWidgetState extends State<AdminPostListWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeCubit.get(context).fetchPosts(collectionName: widget.collectionName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: widget.title,showBackButton: true),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          return state is loadPostLoading || state is deletePostLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: widget.collectionName == 'sabla'
                          ? HomeCubit.get(context).sablaPosts.length
                          : widget.collectionName == 'malab'
                              ? HomeCubit.get(context).malabPosts.length
                              : widget.collectionName == 'souq'
                                  ? HomeCubit.get(context).souqPosts.length
                                  : 0,
                      itemBuilder: (context, index) {
                        PostModel? item =  widget.collectionName == 'sabla'
                            ? HomeCubit.get(context).sablaPosts[index]
                            : widget.collectionName == 'malab'
                            ? HomeCubit.get(context).malabPosts[index]
                            : widget.collectionName == 'souq'
                            ? HomeCubit.get(context).souqPosts[index]
                            : null;
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                                child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListTile(
                                title: Text(
                                    '${item?.title}'),
                                onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostScreen(
                                     postId: item!.uid,
                                     initialTitle: item.title,
                                     initialDescription: item.discription,
                                     initialUrl: item.url,
                                      initialImageUrl: item.image,
                                     initialCollectionPath: widget.collectionName,
                                   )));
                                },
                                //add divider
                                trailing: IconButton(icon:Icon(Icons.delete,color: Colors.red,), onPressed: () {
                                  HomeCubit.get(context).deletePost(collectionPath: widget.collectionName, documentId: item!.uid,imageUrl: item.image);

                                },
                              ),)
                            )),
                          ), //
                        );
                      },
                    ),
                  ),
                  onRefresh: () async {
                    HomeCubit.get(context)
                        .fetchPosts(collectionName: widget.collectionName);
                  });
        },
        listener: (context, state) {
          if(state is deletePostSucces){
            HomeCubit.get(context).fetchPosts(collectionName: widget.collectionName);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم حذف المنشور بنجاح!')),
            );
          }
        },
      ),
    );
  }
}
