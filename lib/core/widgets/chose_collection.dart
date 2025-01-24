import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_styles.dart';

class ChoseCollectionDropdown extends StatefulWidget {
  final Function(String?) onTypeSelected;

  const ChoseCollectionDropdown({Key? key, required this.onTypeSelected}) : super(key: key);

  @override
  _ChoseCollectionDropdownState createState() => _ChoseCollectionDropdownState();
}

class _ChoseCollectionDropdownState extends State<ChoseCollectionDropdown> {
  final List<String> collectionName = ['sabla', 'malab', 'souq']; // Available user types
  String? selectedType; // Currently selected type

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        labelText: "اختر القسم",
        border: buildBorder(),
        labelStyle: TextStyles.bold13.copyWith(
          color: const Color(0xFF949D9E),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFA),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: collectionName.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
        widget.onTypeSelected(value); // Pass the selected type to the parent
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a user type';
        }
        return null;
      },
    );
  }
  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0xFFE6E9E9),
      ),
    );
  }

}