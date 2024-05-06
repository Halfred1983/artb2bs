import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';

class Tags extends StatefulWidget {
  final List<String> choices;
  List<String> selectedValues;
  final Function(List<String>) onSelectionChanged; // Callback function to return selected values

  Tags(this.choices, this.selectedValues, this.onSelectionChanged, {Key? key}) : super(key: key);

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  void setSelectedValues(List<String> values) {
    setState(() {
      widget.selectedValues = values;
      widget.onSelectionChanged(values); // Call callback function to return selected values to parent widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InlineChoice<String>.multiple(
          clearable: true,
          value: widget.selectedValues,
          onChanged: setSelectedValues,
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
          listBuilder: ChoiceList.createWrapped(
            spacing: 10,
            runSpacing: 10,
            // padding: const EdgeInsets.symmetric(
            //   horizontal: 20,
            //   vertical: 25,
            // ),
          ),
        ),
      ],
    );
  }
}
