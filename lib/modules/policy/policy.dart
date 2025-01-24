import 'package:flutter/material.dart';
import 'package:sham/core/utils/app_images.dart';
import 'package:sham/core/widgets/ronded_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';



class Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: 'سياسة الخصوصية',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Introductory Card
              Container(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'يتوجب عليكم الموافقة على هذه البنود (“الأحكام”) للدخول إلى تطبيق شبكة صحم.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Section 1: General Terms
              buildSection(
                title: 'الشروط العامة:',
                content: [
                  'تحتفظ شبكة صحم بحق سحب أو تعديل التطبيق دون أي إشعار مسبق.',
                  'لا تتحمل شبكة صحم مسؤولية تعطل التطبيق في أي وقت من الأوقات.',
                  'يجوز استخدام تطبيق شبكة صحم للأغراض الشخصية فقط.',
                  'سيتم مراقبة ومتابعة محتويات تطبيق شبكة صحم بصورة مستمرة للتأكد من تحسن جودة المحتوى.',
                ],
              ),

              const SizedBox(height: 20.0),

              // Section 2: Privacy Policy
              buildSection(
                title: 'سياسة الخصوصية:',
                content: [
                  'تم إعداد سياسة الاستخدام والخصوصية لمساعدتكم في فهم طبيعة البيانات المعمول بها في شبكة صحم.',
                  'نحن في شبكة صحم نحترم خصوصيتك ونسعى لحماية بياناتك.',
                  'نقوم بجمع المعلومات الأساسية لتحسين تجربة المستخدم.',
                  'نلتزم بعدم مشاركة البيانات مع أي أطراف خارجية.',
                  'سنحافظ في كافة الأوقات على خصوصية وسرية البيانات الشخصية التي نحصل عليها.',
                  'لن يتم إفشاء المعلومات الشخصية إلا إذا كان ذلك مطلوباً بموجب قانوني أو للدفاع عن حماية الحقوق.',
                  'عند الحاجة إلى بيانات خاصة بك، فإننا نطلب منك تقديمها بمحض إرادتك.',
                  'نحتفظ بالحق في تعديل بنود وشروط سياسة خصوصية البيانات إن لزم الأمر ومتى كان ذلك ملائماً.',
                ],
              ),

              const SizedBox(height: 20.0),

              // Contact Section
              Container(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'للتواصل معنا:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Assets.imagesWhatsapIcon, width: 24, height: 24
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '95516675 (واتساب فقط)',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  // Helper method to build a section with a title and list
  Widget buildSection({required String title, required List<String> content}) {
    return Container(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            // Content List
            ...content.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),  Text(
                      '• ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}