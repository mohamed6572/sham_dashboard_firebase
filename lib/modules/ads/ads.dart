import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/widgets/ronded_app_bar.dart';

class ads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title:  'شروط الاعلانات', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 8,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Title
                Center(
                  child: Text(
                    'الشروط والإجراءات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                // Guidelines Header
                Text(
                  'الشروط الواجب التقيد بها قبل التقدم لطلب الإعلان في شبكة صحم:', textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12.0),
                // Step-by-step list
                ...[
                  'عدم تقديم إعلان يحتوي على صور أو كلمات أو نصوص مخالفة للدين الإسلامي.',
                  'لا يحق للمعلن التنازل عن المساحة الإعلانية أو تأجيرها للغير دون علم إدارة تطبيق شبكة صحم.',
                  'حجز أي مساحة إعلانية تعتبر سارية المفعول ابتداءً من تاريخ الإتفاق واستلام مبلغ الإعلان المتفق عليه.',
                  'لا يحق للمعلن إلغاء الإعلان واسترجاع المبلغ لأي ظرف كان.',
                  'الأسعار والشروط قابلة للتغيير في أي وقت دون أن يترتب علينا أي تعويضات للمعلن.',
                ].map(
                      (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step number (bullet point)

                        // Step text
                        Expanded(
                          child: Text(
                            step,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),   Text(
                          '• ',

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),



    );
  }
}
