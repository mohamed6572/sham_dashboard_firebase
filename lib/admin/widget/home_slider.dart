import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/admin/cubit/post_cubit.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

import '../../core/models/ad_pop_up_model.dart';
import '../cubit/post_state.dart';
import 'add_update_home_slider.dart';

class HomeSliderScreen extends StatefulWidget {

  @override
  State<HomeSliderScreen> createState() => _HomeSliderScreenState();
}

class _HomeSliderScreenState extends State<HomeSliderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PostCubit.get(context).fetchHomeSliderData();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = PostCubit.get(context);
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is UploadSliderSuccess) {
          PostCubit.get(context).fetchHomeSliderData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Slider uploaded successfully!')),
          );
        } else if (state is DeleteSliderSuccess) {
          PostCubit.get(context).fetchHomeSliderData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Slider deleted successfully!')),
          );
        }
      },
      builder: (context, state) {


        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddUpdateSliderScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          appBar: buildAppBar(context, title: 'عارض الصور',IfRefresh: true, showBackButton: true),
          body:state is GetSliderLoading?Center(child: CircularProgressIndicator()):cubit.homeAds.isEmpty?
              Center(child: Text('No sliders found!'))
              : ListView.builder(
            itemCount: cubit.homeAds.length,
            itemBuilder: (context, index) {
              final slider = cubit.homeAds[index];

              return ListTile(
                leading: Image.network(slider.imageUrl),
                title: Text(slider.link,maxLines: 2,),
               // subtitle: Text(slider.link),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUpdateSliderScreen(
                              sliderId: slider.id,
                              currentImageUrl: slider.imageUrl,
                              currentText: slider.text,
                              currentLink: slider.link,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,color: Colors.red,),
                      onPressed: () {
                        cubit.deleteSlider(
                          sliderId: slider.id!,
                          imageUrl: slider.imageUrl,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

