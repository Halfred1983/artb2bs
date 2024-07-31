import 'package:artb2b/utils/common.dart';
import 'package:flutter/material.dart';
import '../app/resources/styles.dart';
import '../app/resources/theme.dart';

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
          child: SliderTheme(
            data: AppTheme.theme.sliderTheme, // Apply the custom slider theme
            child: Slider(
              min: 0,
              max: 1000,
              divisions: 100,
              inactiveColor: AppTheme.n200,
              activeColor: AppTheme.n200,
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
        ),
        verticalMargin24,
        Text(
          'Pax ${widget.value}',
          style: TextStyles.boldN90029, textAlign: TextAlign.center,
        ),
      ],
    );
  }
}