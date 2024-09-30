import 'package:choice/choice.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';

class ScrollableChips extends StatefulWidget {
  ScrollableChips({super.key, required this.choices, required this.onSelectionChanged, this.selectedValue});

  final List<String> choices;
  String? selectedValue;
  final Function(String) onSelectionChanged; // Callback function to return selected values


  @override
  State<ScrollableChips> createState() => _ScrollableChipsState();
}

class _ScrollableChipsState extends State<ScrollableChips> {


  void setSelectedValue(String? value) {
    setState(()  {
      widget.selectedValue = value;
      widget.onSelectionChanged(value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Choice<String>.inline(
      clearable: true,
      value: ChoiceSingle.value(widget.selectedValue),
      onChanged: ChoiceSingle.onChanged(setSelectedValue),
      itemCount: widget.choices.length,
      itemBuilder: (state, i) {
        return ChoiceChip(
          selectedColor: AppTheme.primaryColor,
          backgroundColor: AppTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(
              color: AppTheme.accentColor,
              width: 1,
            ),
          ),
          selected: state.selected(widget.choices[i]),
          onSelected: state.onSelected(widget.choices[i]),
          label: Text(widget.choices[i], style: TextStyles.boldN90012),
        );
      },
      listBuilder: ChoiceList.createScrollable(
        spacing: 10,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
