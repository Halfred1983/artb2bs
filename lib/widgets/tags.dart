import 'package:choice/choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  final List<String> choices;
  final List<String> selectedValues;
  final Function(List<String>) onSelectionChanged; // Callback function to return selected values

  Tags(this.choices, this.selectedValues, this.onSelectionChanged, {Key? key}) : super(key: key);

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  void setSelectedValues(List<String> values) {
    setState(() {
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
              selected: state.selected(widget.choices[i]),
              onSelected: state.onSelected(widget.choices[i]),
              label: Text(widget.choices[i]),
            );
          },
          listBuilder: ChoiceList.createWrapped(
            spacing: 10,
            runSpacing: 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
          ),
        ),
      ],
    );
  }
}
