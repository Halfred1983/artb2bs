import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:artb2b/app/resources/assets.dart';
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:artb2b/utils/common.dart';

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    Key? key,
    this.labelText,
    required this.items,
    required this.value,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autoValidateMode,
    this.hint,
    this.focusNode,
  }) : super(key: key);

  final String? labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autoValidateMode;
  final String? hint;
  final FocusNode? focusNode;

  @override
  _AppDropdownFieldState<T> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: AppTheme.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null) ...[
            Text(widget.labelText!, style: TextStyles.semiBoldViolet21),
            verticalMargin8,
          ],
          DropdownButtonFormField<T>(
            dropdownColor: AppTheme.white,
            focusColor: AppTheme.white,
            focusNode: _effectiveFocusNode,
            autofocus: true,
            autovalidateMode: widget.autoValidateMode,
            items: widget.items,
            onChanged: (T? value) {
              _effectiveFocusNode.requestFocus();
              widget.onChanged?.call(value);
            },
            onSaved: widget.onSaved,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppTheme.accentColor, width: 1.0),
              ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: AppTheme.primaryColourViolet, width: 1.0),
                ),
                border: OutlineInputBorder()
            ).applyDefaults(theme.inputDecorationTheme),
            validator: widget.validator,
            value: widget.value,
            hint: widget.hint != null ? Text(widget.hint!) : null,
            style: TextStyles.regularAccent14,
            // icon: SvgPicture.asset(
            //   ImageAssets.trolleyIconChevron,
            //   color: AppTheme.tsBlue001,
            // ),
          ),
        ],
      ),
    );
  }
}
