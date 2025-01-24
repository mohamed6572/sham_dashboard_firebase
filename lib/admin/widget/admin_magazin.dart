import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sham/Layout/cubit/home_cubit.dart';
import 'package:sham/admin/cubit/post_cubit.dart';
import 'package:sham/admin/cubit/post_state.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';
import 'package:sham/modules/home/home.dart';

class AdminMagazin extends StatefulWidget {
  const AdminMagazin({super.key});

  @override
  State<AdminMagazin> createState() => _AdminMagazinState();
}

class _AdminMagazinState extends State<AdminMagazin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    HomeCubit.get(context).fetchPdfLink(collectionPath: 'magazen');
  }

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is deletePDFSucces||state is uploadPDFSuccess) {
    HomeCubit.get(context).fetchPdfLink(collectionPath: 'magazen');
        //  Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('تمت العملية بنجاح')));
        }
      },
      builder: (context, state) {
        return Scaffold(
      appBar: buildAppBar(context, title: 'المجلة', showBackButton: true),
      floatingActionButton:cubit.pdfLink.isNotEmpty ? null: FloatingActionButton(
        onPressed: () {
          HomeCubit.get(context).uploadPdf(collectionPath: 'magazen',);
        },
        child: Icon(Icons.add),
      ),
      body:state is loadPDFLoading || state is deletePDFLoading||state is uploadPDFLoading? Center(child: CircularProgressIndicator(),):

      cubit.pdfLink.isEmpty? Center(child: Text('لا يوجد')):
           Directionality(
            textDirection: TextDirection.rtl,
             child: ListTile(

              title: Text('المجلة'),
              trailing: IconButton(
                  onPressed: () {
                    HomeCubit.get(context).deletePdf(
                        collectionPath: 'magazen',
                        pdfUrl: HomeCubit.get(context).pdfLink);
                  },
                  icon:state is uploadPDFLoading ?CircularProgressIndicator(): Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
                       ),
           )


    );
      },
    );
  }
}
