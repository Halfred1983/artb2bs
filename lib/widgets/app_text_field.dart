import 'package:artb2b/utils/common.dart';
import 'package:artb2b/app/resources/styles.dart';
import 'package:artb2b/app/resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'field_error_text.dart';

@immutable
class AppTextField extends FormField<String> {
  AppTextField({
    Key? key,
    this.controller,
    this.decoration,
    String? initialValue,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.hidden = false,
    this.autoCorrect = true,
    this.autoFocus = false,
    this.enableSuggestions = true,
    bool enabled = true,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String?>? validator,
    this.inputFormatters,
    this.keyboardType,
    this.keyboardAppearance = Brightness.light,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.autofillHints,
  }) : super(
    key: key,
    builder: _AppTextFieldState._builder,
    onSaved: onSaved,
    validator: validator,
    initialValue: controller != null ? controller.text : (initialValue ?? ''),
    enabled: enabled,
    autovalidateMode: autoValidateMode,
  );

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool hidden;
  final bool autoCorrect;
  final bool autoFocus;
  final bool enableSuggestions;
  final AutovalidateMode autoValidateMode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Brightness? keyboardAppearance;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final Iterable<String>? autofillHints;

  static final TextInputFormatter phoneFilter =
  FilteringTextInputFormatter.allow(RegExp(r'[0-9\+]'));

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller!;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  AppTextField get widget => super.widget as AppTextField;

  bool _obscuring = true;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _controller = TextEditingController.fromValue(oldWidget.controller!.value);
      }
      if (widget.controller != null) {
        setValue(widget.controller!.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    // setState will be called in the superclass, so even though state is being
    // manipulated, no setState call is needed here.
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }

  static Widget _builder(FormFieldState<String> field) {
    return (field as _AppTextFieldState).buildFormField();
  }

  Widget buildFormField() {
    final theme = Theme.of(context);

    void onChangedHandler(String value) {
      didChange(value);
      widget.onChanged?.call(value);
    }

    final effectiveDecoration = (widget.decoration ??
        const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            ),
            border: OutlineInputBorder()
        )) //
        .applyDefaults(theme.inputDecorationTheme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.labelText != null) ...[
          Text(widget.labelText!, style: TextStyles.semiBoldLightGrey14),
          verticalMargin8,
        ],
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[_effectiveFocusNode, _effectiveController]),
          builder: (BuildContext context, Widget? child) {
            final isFocused = _effectiveFocusNode.hasFocus;
            final isEmpty = _effectiveController.value.text.isEmpty;
            late final ShapeBorder? border;
            if (!widget.enabled) {
              border = effectiveDecoration.disabledBorder;
            } else if (isFocused) {
              border = effectiveDecoration.focusedBorder;
            } else {
              border = effectiveDecoration.enabledBorder;
            }
            return Material(
              color: theme.inputDecorationTheme.fillColor,
              shape: border,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (widget.hintText != null)
                    PositionedDirectional(
                      top: 0,
                      start: 0,
                      end: 0,
                      child: Visibility(
                        visible: isEmpty && !(effectiveDecoration.prefix != null && isFocused),
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: IgnorePointer(
                          child: Padding(
                            padding: effectiveDecoration.contentPadding ?? EdgeInsets.zero,
                            child: Text(
                              widget.hintText!,
                              textAlign: TextAlign.start,
                              style: effectiveDecoration.hintStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  child!,
                ],
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: widget.hidden ? 0.0 : 1.0,
                  child: TextField(
                    onTap: widget.onTap,
                    controller: _effectiveController,
                    focusNode: _effectiveFocusNode,
                    decoration: effectiveDecoration,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    obscureText: widget.obscureText ? _obscuring : false,
                    obscuringCharacter: '\u25cf',
                    autocorrect: widget.autoCorrect,
                    autofocus: widget.autoFocus,
                    enableSuggestions: widget.enableSuggestions,
                    enabled: widget.enabled,
                    onChanged: onChangedHandler,
                    onEditingComplete: widget.onEditingComplete,
                    onSubmitted: widget.onFieldSubmitted,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.keyboardType,
                    keyboardAppearance: widget.keyboardAppearance,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    expands: widget.expands,
                    maxLength: widget.maxLength,
                    maxLengthEnforcement: widget.maxLengthEnforcement,
                    autofillHints: widget.autofillHints,
                  ),
                ),
              ),
              if (widget.obscureText)
                ExcludeFocus(
                  child: IconButton(
                    onPressed: () {
                      _effectiveFocusNode.requestFocus();
                      setState(() => _obscuring = !_obscuring);
                    },
                    icon: AnimatedBuilder(
                      animation: _effectiveFocusNode,
                      builder: (BuildContext context, Widget? child) {
                        return Icon(
                          _obscuring ? Icons.visibility_off : Icons.visibility,
                          color: _effectiveFocusNode.hasFocus //
                              ? AppTheme.accentColourOrange
                              : AppTheme.backgroundGrey,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
        FieldErrorText(errorText: errorText),
      ],
    );
  }
}
