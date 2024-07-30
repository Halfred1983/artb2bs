import 'package:artb2b/app/resources/theme.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../utils/common.dart';
import '../utils/currency/currency_helper.dart';

class NumberSlider extends StatefulWidget {
  int? value;
  final Function(int) onChanged;


  NumberSlider({super.key, required this.value, required this.onChanged});
  @override
  _NumberSliderState createState() => _NumberSliderState();
}

class _NumberSliderState extends State<NumberSlider> {
  int _currentValue = 0;
  final TextEditingController _minController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? 0;
    _minController.text = _currentValue.toString();
    // _minController.addListener(_updateMinValue);
  }

  @override
  void dispose() {
    _minController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Slider(
            min: 0,
            max: 1000,
            divisions: 100,
            inactiveColor: AppTheme.n200,
            activeColor: AppTheme.n200,
            label: _currentValue.toString(),
            onChanged: (double value) {
              setState(() {
                _currentValue = value.toInt();
                _minController.text = _currentValue.toString();
              });
              widget.onChanged(_currentValue);
            },
            value: _currentValue.toDouble(),
          ),
        ),
        verticalMargin24,
        Text(
          'Pax ${widget.value}',
          style: TextStyles.boldN90029, textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // void _updateMinValue() {
  //   double newStart = _minController.text.isEmpty ? 0 : double.parse(
  //       _minController.text);
  //   if (newStart <= _currentRangeValues.end) {
  //     setState(() {
  //       _currentRangeValues = RangeValues(newStart, _currentRangeValues.end);
  //     });
  //   } else {
  //     // Handle the error, e.g., by resetting the text field to the current start value
  //     _minController.text = _currentRangeValues.start.round().toString();
  //   }
  // }
}