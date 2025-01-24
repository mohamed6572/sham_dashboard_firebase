import 'package:flutter/material.dart';
import '../../core/widgets/ronded_app_bar.dart';

class Who_are extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: buildAppBar(
        context,
        title: 'من نحن',
        showBackButton: true,
      ),
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
                offset: Offset(0, 4), // Changes the position of the shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Title
                Text(
                  'من نحن',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                // Content Text
                Text(
                  '''بما إن التكنلوجيا تلعب دوراً مهماً وحيوياً في الحياة المعاصرة، فبكل فخر وإعتزاز نضع بين أيدي أبناء ولاية صحم هذا التطبيق، الذي يعد وسيلة من وسائل التواصل الإجتماعي الخاص بأهالي ولاية صحم الكرام.
      
      يسلط هذا التطبيق الضوء على أبرز الأحداث والعناوين والإهتمامات التي تلقى رواجاً من أبناء الولاية.
      
      آملين أن يتصدر هذا العمل إهتماماً وإنتشاراً من كافة أبناء الولاية.''',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white, // Subtle background color
    );
  }
}