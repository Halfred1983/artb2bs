import 'package:artb2b/app/resources/theme.dart';
import 'package:database_service/database.dart';
import 'package:flutter/material.dart';

import '../app/resources/styles.dart';
import '../utils/common.dart';
import '../utils/currency/currency_helper.dart';

class PriceSlider extends StatefulWidget {
  final User user;
  RangeValues? rangeValues;
  final Function(RangeValues) onChanged;


  PriceSlider({super.key, required this.user, this.rangeValues, required this.onChanged});
  @override
  _PriceSliderState createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  RangeValues _currentRangeValues = const RangeValues(20, 80);
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.rangeValues ?? const RangeValues(20, 80);
    _minController.text = _currentRangeValues.start.round().toString();
    _maxController.text = _currentRangeValues.end.round().toString();
    _minController.addListener(_updateMinValue);
    _maxController.addListener(_updateMaxValue);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 300,
            divisions: 100,
            inactiveColor: AppTheme.n500,
            activeColor: AppTheme.accentColor,
            labels: RangeLabels(
              _currentRangeValues.start.round().toString(),
              _currentRangeValues.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                _minController.text = _currentRangeValues.start.round().toString();
                _maxController.text = _currentRangeValues.end.round().toString();
              });
              widget.onChanged(_currentRangeValues);
            },
          ),
        ),
        verticalMargin24,
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 56,
                child: TextField(
                  controller: _minController,
                  decoration: InputDecoration(
                    suffix: Text(CurrencyHelper.currency(widget.user.userInfo!.address!.country).currencySymbol),
                    hintText: 'Minimum',
                    hintStyle: TextStyles.regularN90014,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            horizontalMargin24,
            Container(
              width: 20,
              height: 1,
              decoration: ShapeDecoration(
                color: AppTheme.s400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            horizontalMargin24,
            Expanded(
              child: SizedBox(
                height: 56,
                child: TextField(
                  controller: _maxController,
                  decoration: InputDecoration(
                    suffix: Text(CurrencyHelper.currency(widget.user.userInfo!.address!.country).currencySymbol),
                    hintText: 'Maximum',
                    hintStyle: TextStyles.regularN90014,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppTheme.accentColor),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            // Text('Start: ${_currentRangeValues.start.round()}'),
            // Text('End: ${_currentRangeValues.end.round()}'),
          ],
        ),
      ],
    );
  }

  void _updateMinValue() {
    double newStart = _minController.text.isEmpty ? 0 : double.parse(
        _minController.text);
    if (newStart <= _currentRangeValues.end) {
      setState(() {
        _currentRangeValues = RangeValues(newStart, _currentRangeValues.end);
      });
    } else {
      // Handle the error, e.g., by resetting the text field to the current start value
      _minController.text = _currentRangeValues.start.round().toString();
    }
  }

  void _updateMaxValue() {
    double newEnd = _maxController.text.isEmpty ? 0 : double.parse(_maxController.text);
    if (newEnd >= _currentRangeValues.start) {
      setState(() {
        _currentRangeValues = RangeValues(_currentRangeValues.start, newEnd);
      });
    } else {
      // Handle the error, e.g., by resetting the text field to the current end value
      _maxController.text = _currentRangeValues.end.round().toString();
    }
  }
}