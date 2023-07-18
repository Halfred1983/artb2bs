import 'package:artb2b/app/resources/theme.dart';
import 'package:flutter/material.dart';

class TextStyles {
  const TextStyles._();

  // Regular
  static final regularGreen21 = _baseRegular[TextSize.size21].withColor(AppTheme.primaryColourViolet);
  static final regularWhite16 = _baseRegular[TextSize.size16].withColor(AppTheme.white);
  static final regularAccent24 = _baseRegular[TextSize.size24].withColor(AppTheme.accentColor);
  static final regularAccent16 = _baseRegular[TextSize.size16].withColor(AppTheme.accentColor);
  static final regularDarkGrey16 = _baseRegular[TextSize.size16].withColor(AppTheme.black);
  static final regularGrey24 = _baseRegular[TextSize.size24].withColor(AppTheme.backgroundGrey);
  static final regularAccent14 = _baseRegular[TextSize.size14].withColor(AppTheme.accentColor);

  // Semi-bold
  static final semiBoldViolet14 = _baseSemiBold[TextSize.size14].withColor(AppTheme.primaryColourViolet);
  static final semiBoldLightGrey16 = _baseSemiBold[TextSize.size16].withColor(AppTheme.fideuramGreenArtist001);
  static final semiBolViolet16 = _baseSemiBold[TextSize.size16].withColor(AppTheme.primaryColourViolet);
  static final semiBolDarkGrey21 = _baseSemiBold[TextSize.size21].withColor(AppTheme.black);
  static final semiBolAccent14 = _baseSemiBold[TextSize.size14].withColor(AppTheme.accentColor);
  static final semiBoldAccent16 = _baseSemiBold[TextSize.size16].withColor(AppTheme.accentColor);
  static final semiBoldViolet21 = _baseSemiBold[TextSize.size21].withColor(AppTheme.primaryColourViolet);

  // Bold
  static final boldGreen21 = _baseBold[TextSize.size21].withColor(AppTheme.primaryColourViolet);
  static final boldViolet16 = _baseBold[TextSize.size16].withColor(AppTheme.primaryColourViolet);
  static final boldAccent24 = _baseBold[TextSize.size24].withColor(AppTheme.accentColor);
  static final boldDarkGrey21 = _baseBold[TextSize.size21].withColor(AppTheme.black);
  static final boldDarkGrey16 = _baseBold[TextSize.size16].withColor(AppTheme.black);

  // Bold Underlined


  // Regular Underlined
  // static final regularUnderlinedGreen2 = _baseRegular[TextSize.size2]!.copyWith(
  //   color: AppTheme.fideuramGreen001,
  //   decoration: TextDecoration.underline,
  // );

  // --------------------------------------------------------------------------

  static final _baseRegular = <TextSize, TextStyle>{
    TextSize.size0: createBaseTextStyle(TextWeight.regular, TextSize.size0),
    TextSize.size1: createBaseTextStyle(TextWeight.regular, TextSize.size1),
    TextSize.size2: createBaseTextStyle(TextWeight.regular, TextSize.size2),
    TextSize.size16: createBaseTextStyle(TextWeight.regular, TextSize.size16),
    TextSize.size21: createBaseTextStyle(TextWeight.regular, TextSize.size21),
    TextSize.size6: createBaseTextStyle(TextWeight.regular, TextSize.size6),
    TextSize.size24: createBaseTextStyle(TextWeight.regular, TextSize.size24),
    TextSize.size8: createBaseTextStyle(TextWeight.regular, TextSize.size8),
    TextSize.size14: createBaseTextStyle(TextWeight.regular, TextSize.size14),
  };

  static final _baseSemiBold = <TextSize, TextStyle>{
    TextSize.size0: createBaseTextStyle(TextWeight.semiBold, TextSize.size0),
    TextSize.size1: createBaseTextStyle(TextWeight.semiBold, TextSize.size1),
    TextSize.size2: createBaseTextStyle(TextWeight.semiBold, TextSize.size2),
    TextSize.size16: createBaseTextStyle(TextWeight.semiBold, TextSize.size16),
    TextSize.size14: createBaseTextStyle(TextWeight.semiBold, TextSize.size14),
    TextSize.size21: createBaseTextStyle(TextWeight.semiBold, TextSize.size21),
    TextSize.size6: createBaseTextStyle(TextWeight.semiBold, TextSize.size6),
    TextSize.size24: createBaseTextStyle(TextWeight.semiBold, TextSize.size24),
    TextSize.size8: createBaseTextStyle(TextWeight.semiBold, TextSize.size8),
  };

  static final _baseBold = <TextSize, TextStyle>{
    TextSize.size0: createBaseTextStyle(TextWeight.bold, TextSize.size0),
    TextSize.size1: createBaseTextStyle(TextWeight.bold, TextSize.size1),
    TextSize.size2: createBaseTextStyle(TextWeight.bold, TextSize.size2),
    TextSize.size16: createBaseTextStyle(TextWeight.bold, TextSize.size16),
    TextSize.size21: createBaseTextStyle(TextWeight.bold, TextSize.size21),
    TextSize.size6: createBaseTextStyle(TextWeight.bold, TextSize.size6),
    TextSize.size24: createBaseTextStyle(TextWeight.bold, TextSize.size24),
    TextSize.size8: createBaseTextStyle(TextWeight.bold, TextSize.size8),
  };

  // static final _baseBoldUnder = <TextSize, TextStyle>{
  //   TextSize.size0: createBaseTextStyle(TextWeight.bold, TextSize.size0, underline: true),
  //   TextSize.size1: createBaseTextStyle(TextWeight.bold, TextSize.size1, underline: true),
  //   TextSize.size2: createBaseTextStyle(TextWeight.bold, TextSize.size2, underline: true),
  //   TextSize.size3: createBaseTextStyle(TextWeight.bold, TextSize.size3, underline: true),
  //   TextSize.size16: createBaseTextStyle(TextWeight.bold, TextSize.size16, underline: true),
  //   TextSize.size21: createBaseTextStyle(TextWeight.bold, TextSize.size21, underline: true),
  //   TextSize.size6: createBaseTextStyle(TextWeight.bold, TextSize.size6, underline: true),
  //   TextSize.size24: createBaseTextStyle(TextWeight.bold, TextSize.size24, underline: true),
  //   TextSize.size8: createBaseTextStyle(TextWeight.bold, TextSize.size8, underline: true),
  // };

  static TextStyle createBaseTextStyle(TextWeight weight, TextSize size,
      {Color? color, double? lineHeight, bool underline = false}) {
    final fontSize = _fontSizes[size]!;
    return TextStyle(
      fontFamily: 'Avenir',
      fontWeight: _fontWeights[weight]!,
      fontSize: fontSize,
      decoration: underline ? TextDecoration.underline : null,
      height: (lineHeight ?? _lineHeights[size]!) / fontSize,
    );
  }

  static const _fontWeights = <TextWeight, FontWeight>{
    TextWeight.light: FontWeight.w300,
    TextWeight.regular: FontWeight.w400,
    TextWeight.semiBold: FontWeight.w600,
    TextWeight.bold: FontWeight.w700,
  };

  static const _fontSizes = <TextSize, double>{
    TextSize.size0: 13.0,
    TextSize.size14: 14.0,
    TextSize.size1: 12.0,
    TextSize.size2: 16.0,
    TextSize.size16: 16.0,
    TextSize.size21: 21.0,
    TextSize.size6: 21.0,
    TextSize.size24: 24.0,
    TextSize.size8: 27.0,
  };

  static const _lineHeights = <TextSize, double>{
    TextSize.size0: 19.0,
    TextSize.size14: 19.0,
    TextSize.size1: 19.0,
    TextSize.size2: 19.0,
    TextSize.size16: 19.0,
    TextSize.size21: 25.0,
    TextSize.size6: 19.0,
    TextSize.size24: 19.0,
    TextSize.size8: 19.0,
  };
}

enum TextSize { size0, size1, size2, size16, size21, size6, size24, size8, size14 }

enum TextWeight { light, regular, semiBold, bold }

extension TextStyleWithColor on TextStyle? {
  TextStyle withColor(Color color) => this!.copyWith(color: color);
}
