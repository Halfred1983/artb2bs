import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../app/resources/theme.dart';

class Tags extends StatefulWidget {
  final List<String> choices;
  List<String> selectedValues;
  final Function(List<String>) onSelectionChanged; // Callback function to return selected values
  final bool isScrollable; // New optional parameter
  final bool isMultiple; // New optional parameter

  Tags(this.choices, this.selectedValues, this.onSelectionChanged,
      {Key? key, this.isScrollable = false, this.isMultiple = true}) : super(key: key);

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
        widget.isMultiple ? InlineChoice<String>.multiple(
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
          listBuilder: widget.isScrollable
              ? ChoiceList.createScrollable(
            spacing: 10,
            padding: const EdgeInsets.symmetric(
              // horizontal: 20,
              vertical: 12,
            ),
          )
              : ChoiceList.createWrapped(
            spacing: 10,
            runSpacing: 10,
          ),
        ) :
        InlineChoice<String>.single(
          clearable: true,
          value: widget.selectedValues.isNotEmpty ? widget.selectedValues[0] : null,
          onChanged: (value) {
            setSelectedValues([value!]);
          },
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
          listBuilder: widget.isScrollable
              ? ChoiceList.createScrollable(
            spacing: 10,
            padding: const EdgeInsets.symmetric(
              // horizontal: 20,
              vertical: 12,
            ),
          )
              : ChoiceList.createWrapped(
            spacing: 10,
            runSpacing: 10,
          ),
        ),
      ],
    );
  }
}
