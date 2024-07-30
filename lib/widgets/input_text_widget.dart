
import 'package:flutter/material.dart';

import '../app/resources/theme.dart';
import 'app_input_validators.dart';
import 'app_text_field.dart';

class InputTextWidget extends StatefulWidget {
  const InputTextWidget(this.nameChanged, this.hint, [this.textInputType]);
  final ValueChanged<String> nameChanged;
  final String hint;
  final TextInputType? textInputType;


  @override
  State<InputTextWidget> createState() =>
      _InputTextWidgetState(nameChanged, hint, textInputType);
}

class _InputTextWidgetState extends State<InputTextWidget> {

  late final TextEditingController _nameController;
  final ValueChanged<String> _nameChanged;
  final String _hint;
  final TextInputType? _textInputType;

  _InputTextWidgetState(this._nameChanged, this._hint, this._textInputType);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      key: const Key('Spaces'),
      controller: _nameController,
      hintText: _hint,
      textInputAction: TextInputAction.next,
      keyboardType: _textInputType ?? TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      onChanged: _nameChanged,
      decoration: AppTheme.textInputDecoration.copyWith(hintText: 'What is in the picture?')
    );
  }
}