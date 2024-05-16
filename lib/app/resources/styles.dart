import 'package:artb2b/app/resources/theme.dart';
import 'package:flutter/material.dart';

class TextStyles {
  const TextStyles._();


  // Regular
  static final regularPrimary10 = _baseRegular[TextSize.size10].withColor(AppTheme.primaryColor);
  static final regularPrimary12 = _baseRegular[TextSize.size12].withColor(AppTheme.primaryColor);
  static final regularN50012 = _baseRegular[TextSize.size12].withColor(AppTheme.n500);
  static final regularPrimary14 = _baseRegular[TextSize.size14].withColor(AppTheme.primaryColor);
  static final regularPrimary17 = _baseRegular[TextSize.size17].withColor(AppTheme.primaryColor);
  static final regularPrimary20 = _baseRegular[TextSize.size20].withColor(AppTheme.primaryColor);
  static final regularPrimary24 = _baseRegular[TextSize.size24].withColor(AppTheme.primaryColor);
  static final regularPrimary29 = _baseRegular[TextSize.size29].withColor(AppTheme.primaryColor);

  static final regularAccent10 = _baseRegular[TextSize.size10].withColor(AppTheme.accentColor);
  static final regularAccent12 = _baseRegular[TextSize.size12].withColor(AppTheme.accentColor);
  static final regularAccent14 = _baseRegular[TextSize.size14].withColor(AppTheme.accentColor);
  static final regularN200 = _baseRegular[TextSize.size14].withColor(AppTheme.n200);
  static final regularAccent17 = _baseRegular[TextSize.size17].withColor(AppTheme.accentColor);
  static final regularWhite17 = _baseRegular[TextSize.size17].withColor(AppTheme.white);
  static final regularAccent20 = _baseRegular[TextSize.size20].withColor(AppTheme.accentColor);
  static final regularAccent24 = _baseRegular[TextSize.size24].withColor(AppTheme.accentColor);
  static final regularAccent29 = _baseRegular[TextSize.size29].withColor(AppTheme.accentColor);

  static final regularN90010 = _baseRegular[TextSize.size10].withColor(AppTheme.n900);
  static final regularN90012 = _baseRegular[TextSize.size12].withColor(AppTheme.n900);
  static final regularN10012 = _baseRegular[TextSize.size12].withColor(AppTheme.n100);
  static final regularN90014 = _baseRegular[TextSize.size14].withColor(AppTheme.n900);
  static final regularN90017 = _baseRegular[TextSize.size17].withColor(AppTheme.n900);
  static final regularN90020 = _baseRegular[TextSize.size20].withColor(AppTheme.n900);
  static final regularN90024 = _baseRegular[TextSize.size24].withColor(AppTheme.n900);
  static final regularN90029 = _baseRegular[TextSize.size29].withColor(AppTheme.n900);



  // Semi-bold
  static final semiBoldPrimary10 = _baseSemiBold[TextSize.size10].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary12 = _baseSemiBold[TextSize.size12].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary14 = _baseSemiBold[TextSize.size14].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary17 = _baseSemiBold[TextSize.size17].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary20 = _baseSemiBold[TextSize.size20].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary24 = _baseSemiBold[TextSize.size24].withColor(AppTheme.primaryColor);
  static final semiBoldPrimary29 = _baseSemiBold[TextSize.size29].withColor(AppTheme.primaryColor);

  static final semiBoldAccent10 = _baseSemiBold[TextSize.size10].withColor(AppTheme.accentColor);
  static final semiBoldAccent12 = _baseSemiBold[TextSize.size12].withColor(AppTheme.accentColor);
  static final semiBoldAccent14 = _baseSemiBold[TextSize.size14].withColor(AppTheme.accentColor);
  static final semiBoldAccent17 = _baseSemiBold[TextSize.size17].withColor(AppTheme.accentColor);
  static final semiBoldAccent20 = _baseSemiBold[TextSize.size20].withColor(AppTheme.accentColor);
  static final semiBoldAccent24 = _baseSemiBold[TextSize.size24].withColor(AppTheme.accentColor);
  static final semiBoldAccent29 = _baseSemiBold[TextSize.size29].withColor(AppTheme.accentColor);

  static final semiBoldN90010 = _baseSemiBold[TextSize.size10].withColor(AppTheme.n900);
  static final semiBoldP40010 = _baseSemiBold[TextSize.size10].withColor(AppTheme.p400);
  static final semiBoldN90012 = _baseSemiBold[TextSize.size12].withColor(AppTheme.n900);
  static final semiBoldS40012 = _baseSemiBold[TextSize.size12].withColor(AppTheme.s400);
  static final semiBoldS40014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.s400);
  static final semiBoldP40012 = _baseSemiBold[TextSize.size12].withColor(AppTheme.p400);
  static final semiBoldN90014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.n900);
  static final semiBoldN20014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.n200);
  static final semiBoldN10014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.n100);
  static final semiBoldSV30014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.sv300);
  static final semiBoldN60014 = _baseSemiBold[TextSize.size14].withColor(AppTheme.n600);
  static final semiBoldN90017 = _baseSemiBold[TextSize.size17].withColor(AppTheme.n900);
  static final semiBoldN90020 = _baseSemiBold[TextSize.size20].withColor(AppTheme.n900);
  static final semiBoldN90024 = _baseSemiBold[TextSize.size24].withColor(AppTheme.n900);
  static final semiBoldN90029 = _baseSemiBold[TextSize.size29].withColor(AppTheme.n900);


  // Bold
  static final boldPrimary10 =_baseBold[TextSize.size10].withColor(AppTheme.primaryColor);
  static final boldPrimary12 =_baseBold[TextSize.size12].withColor(AppTheme.primaryColor);
  static final boldPrimary14 =_baseBold[TextSize.size14].withColor(AppTheme.primaryColor);
  static final boldPrimary17 =_baseBold[TextSize.size17].withColor(AppTheme.primaryColor);
  static final boldPrimary20 =_baseBold[TextSize.size20].withColor(AppTheme.primaryColor);
  static final boldPrimary24 =_baseBold[TextSize.size24].withColor(AppTheme.primaryColor);
  static final boldPrimary29 =_baseBold[TextSize.size29].withColor(AppTheme.primaryColor);

  static final boldAccent10 = _baseBold[TextSize.size10].withColor(AppTheme.accentColor);
  static final boldAccent12 = _baseBold[TextSize.size12].withColor(AppTheme.accentColor);
  static final boldAccent14 = _baseBold[TextSize.size14].withColor(AppTheme.accentColor);
  static final boldAccent17 = _baseBold[TextSize.size17].withColor(AppTheme.accentColor);
  static final boldAccent20 = _baseBold[TextSize.size20].withColor(AppTheme.accentColor);
  static final boldAccent24 = _baseBold[TextSize.size24].withColor(AppTheme.accentColor);
  static final boldAccent29 = _baseBold[TextSize.size29].withColor(AppTheme.accentColor);

  static final boldN90010 = _baseBold[TextSize.size10].withColor(AppTheme.n900);
  static final boldN90012 = _baseBold[TextSize.size12].withColor(AppTheme.n900);
  static final boldN90016 = _baseBold[TextSize.size17].withColor(AppTheme.n900);
  static final boldN90014 = _baseBold[TextSize.size14].withColor(AppTheme.n900);
  static final boldN90017 = _baseBold[TextSize.size17].withColor(AppTheme.n900);
  static final boldS40017 = _baseBold[TextSize.size17].withColor(AppTheme.s400);
  static final boldN90020 = _baseBold[TextSize.size20].withColor(AppTheme.n900);
  static final boldN90024 = _baseBold[TextSize.size24].withColor(AppTheme.n900);
  static final boldN90029 = _baseBold[TextSize.size29].withColor(AppTheme.n900);
  static final boldWhite29 = _baseBold[TextSize.size29].withColor(AppTheme.white);
  static final boldS40029 = _baseBold[TextSize.size29].withColor(AppTheme.s400);
  static final boldP40029 = _baseBold[TextSize.size29].withColor(AppTheme.p400);

  // Bold Underlined


  // Regular Underlined
  // static final regularUnderlinedGreen2 = _baseRegular[TextSize.size2]!.copyWith(
  //   color: AppTheme.fideuramGreen001,
  //   decoration: TextDecoration.underline,
  // );

  // --------------------------------------------------------------------------

  static final _baseRegular = <TextSize, TextStyle>{
    TextSize.size10: createBaseTextStyle(TextWeight.regular, TextSize.size10),
    TextSize.size12: createBaseTextStyle(TextWeight.regular, TextSize.size12),
    TextSize.size14: createBaseTextStyle(TextWeight.regular, TextSize.size14),
    TextSize.size17: createBaseTextStyle(TextWeight.regular, TextSize.size17),
    TextSize.size20: createBaseTextStyle(TextWeight.regular, TextSize.size20),
    TextSize.size24: createBaseTextStyle(TextWeight.regular, TextSize.size24),
    TextSize.size29: createBaseTextStyle(TextWeight.regular, TextSize.size29),
  };

  static final _baseSemiBold = <TextSize, TextStyle>{
    TextSize.size10: createBaseTextStyle(TextWeight.semiBold, TextSize.size10),
    TextSize.size12: createBaseTextStyle(TextWeight.semiBold, TextSize.size12),
    TextSize.size14: createBaseTextStyle(TextWeight.semiBold, TextSize.size14),
    TextSize.size17: createBaseTextStyle(TextWeight.semiBold, TextSize.size17),
    TextSize.size20: createBaseTextStyle(TextWeight.semiBold, TextSize.size20),
    TextSize.size24: createBaseTextStyle(TextWeight.semiBold, TextSize.size24),
    TextSize.size29: createBaseTextStyle(TextWeight.semiBold, TextSize.size29),
  };

  static final _baseBold = <TextSize, TextStyle>{
    TextSize.size10: createBaseTextStyle(TextWeight.bold, TextSize.size10),
    TextSize.size12: createBaseTextStyle(TextWeight.bold, TextSize.size12),
    TextSize.size14: createBaseTextStyle(TextWeight.bold, TextSize.size14),
    TextSize.size17: createBaseTextStyle(TextWeight.bold, TextSize.size17),
    TextSize.size20: createBaseTextStyle(TextWeight.bold, TextSize.size20),
    TextSize.size24: createBaseTextStyle(TextWeight.bold, TextSize.size24),
    TextSize.size29: createBaseTextStyle(TextWeight.bold, TextSize.size29),
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
      fontFamily: 'OpenSans',
      fontWeight: _fontWeights[weight]!,
      fontStyle: FontStyle.normal,
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
    TextSize.size10: 11.0,
    TextSize.size12: 12.0,
    TextSize.size14: 14.0,
    TextSize.size17: 17.0,
    TextSize.size20: 20.0,
    TextSize.size24: 24.0,
    TextSize.size29: 29.0,
  };

  static const _lineHeights = <TextSize, double>{
    TextSize.size10: 12.0,
    TextSize.size12: 16.0,
    TextSize.size14: 19.0,
    TextSize.size17: 19.0,
    TextSize.size20: 19.0,
    TextSize.size24: 19.0,
    TextSize.size29: 35.0,
  };
}

enum TextSize { size10, size12, size14, size17, size20, size24, size29 }

enum TextWeight { light, regular, semiBold, bold }

extension TextStyleWithColor on TextStyle? {
  TextStyle withColor(Color color) => this!.copyWith(color: color);
}
