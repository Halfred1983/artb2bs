import 'package:flutter/material.dart';
import '../../app/resources/theme.dart';
import '../app/resources/styles.dart';

class DropdownBox extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const DropdownBox({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hintText = 'Please select an option', // Default hint text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      decoration: AppTheme.textInputDecoration.copyWith(hintText: hintText),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyles.semiBoldN90014),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}