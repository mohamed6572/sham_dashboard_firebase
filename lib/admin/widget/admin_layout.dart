import 'package:flutter/material.dart';
import 'package:sham/admin/widget/admin_add_pop_up.dart';
import 'package:sham/admin/widget/admin_magazin.dart';
import 'package:sham/admin/widget/admin_post_list_widget.dart';
import 'package:sham/admin/widget/home_slider.dart';
import 'package:sham/admin/widget/magazen_add_pop_up.dart';
import 'package:sham/admin/widget/malab_add_pop_up.dart';
import 'package:sham/admin/widget/sabla_add_pop_up.dart';
import 'package:sham/admin/widget/souq_add_pop_up.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';

class AdminLayout extends StatelessWidget {
  AdminLayout({super.key});
  List<Map<String, String>> data = [
    {'name': 'السبلة', 'collection': 'sabla'},
    {'name': 'الملعب', 'collection': 'malab'},
    {'name': 'السوق', 'collection': 'souq'},
    {'name': 'المجلة', 'collection': 'magazen'},
    {'name': 'اعلان الصفحة الرئيسية', 'collection': 'adPopUp'},
    {'name': 'اعلان السبله', 'collection': 'adPopUp_sabla'},
    {'name': 'اعلان الملعب', 'collection': 'adPopUp_malab'},
    {'name': 'اعلان السوق', 'collection': 'adPopUp_souq'},
    {'name': 'اعلان المجله', 'collection': 'adPopUp_magazen'},
    {'name': 'عارض الصور', 'collection': 'home_slider'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          title: 'صفحه التحكم', showBackButton: false, IFcreate: true),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${data[index]['name']}'),
                onTap: () {
                  if (data[index]['collection'] == 'sabla' ||
                      data[index]['collection'] == 'malab' ||
                      data[index]['collection'] == 'souq') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminPostListWidget(
                                  collectionName:
                                      data[index]['collection'] ?? '',
                                  title: data[index]['collection'] == 'sabla'
                                      ? 'السبلة'
                                      : data[index]['collection'] == 'malab'
                                          ? 'الملعب'
                                          : 'السوق',
                                )));
                  }
                  if (data[index]['collection'] == 'magazen') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminMagazin()));
                  }
                  if (data[index]['collection'] == 'adPopUp') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminAddPopUp()));
                  }
                  if (data[index]['collection'] == 'adPopUp_sabla') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SablaAddPopUp()));
                  }
                  if (data[index]['collection'] == 'adPopUp_malab') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MalabAddPopUp()));
                  }
                  if (data[index]['collection'] == 'adPopUp_souq') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SouqAddPopUp()));
                  }
                  if (data[index]['collection'] == 'adPopUp_magazen') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MagazenAddPopUp()));
                  }
                  if (data[index]['collection'] == 'home_slider') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeSliderScreen()));
                  }
                },
                //add divider
                trailing: Icon(Icons.arrow_forward_ios),
              );
            },
            itemCount: data.length,
          ),
        ),
      ),
    );
  }
}
