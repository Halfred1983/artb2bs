import 'package:artb2b/app/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
export 'package:flutter/services.dart' show SystemUiOverlayStyle;

class AppTheme {
  const AppTheme._();

  static const backgroundColor = backgroundGrey;
  static const primaryColor = Color(0xFFC9F032);
  static const accentColor = Color(0xFF97B426);


  static const s300 = Color(0xFF97b426);
  static const s400 = Color(0xFF6a7e1b);
  static const p400 = Color(0xFF8da823);
  static const n900 = Color(0xFF292730);
  static const n200 = Color(0xFF8e8c92);






  static const accentColourOrangeOpacity = Color.fromRGBO(232,95,74,0.5);
  static const primaryColourVioletOpacity = Color.fromRGBO(146,46,142,0.6);
  static const secondaryColourRed = Color(0xFFA40500);
  static const white = Color(0xFFFFFFFF);
  static const backgroundGrey = Color(0xFFF9F9F9);
  static const black = Color(0xFF0D0D0D);
  static const grey = Color(0xFFF9F9F9);



  static const primaryColorArtist = primaryCalendarViolet;
  static const primaryCalendarViolet = Color(0xB2E3BDFF);
  static const accentColorArtist = Color(0x95C8ECFF);
  static const backgroundColorArtist = Color(0x95C8ECFF);
  static const fideuramGreyArtist001 = Color(0x95C8ECFF);

  static const primaryColorGallery = fideuramGreenGallery001;
  static const fideuramGreenGallery001 = Color(0xEABC67B2);
  static const accentColorGallery = Color(0xEABC67B2);
  static const backgroundColorGallery = Color(0xEABC67B2);
  static const fideuramGreyGalleryt001 = Color(0x6BDE8295);


  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      canvasColor: Colors.white,
      fontFamily: 'OpenSans',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: backgroundColor,
      splashColor: accentColor.withOpacity(0.2),
      highlightColor: accentColor.withOpacity(0.2),
      appBarTheme: _appBarTheme,
      floatingActionButtonTheme: _floatingActionButton,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlineButtonTheme,
      textButtonTheme: _textButtonTheme,
      unselectedWidgetColor: primaryColor,
      sliderTheme:  SliderThemeData(
        showValueIndicator: ShowValueIndicator.always,
          valueIndicatorTextStyle:  TextStyles.boldAccent17,
          valueIndicatorColor: accentColourOrangeOpacity
      ),
      // textTheme:  const TextTheme(
      //     titleMedium: TextStyle(color: accentColor)
      // ),
      // textSelectionTheme: const TextSelectionThemeData(
      //     cursorColor: accentColor
      // ),
    );
  }

  static ThemeData get themeArtist {
    return ThemeData(
        primaryColor: primaryColorArtist,
        canvasColor: Colors.white,
        backgroundColor: backgroundColorArtist,
        scaffoldBackgroundColor: backgroundColorArtist,
        splashColor: accentColor.withOpacity(0.2),
        highlightColor: accentColor.withOpacity(0.2),
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        // outlinedButtonTheme: _outlineButtonTheme,
        unselectedWidgetColor: fideuramGreyArtist001
    );
  }

  static ThemeData get themeGallery {
    return ThemeData(
        primaryColor: primaryColorGallery,
        canvasColor: Colors.white,
        backgroundColor: backgroundColorGallery,
        scaffoldBackgroundColor: backgroundColorGallery,
        splashColor: accentColor.withOpacity(0.2),
        highlightColor: accentColor.withOpacity(0.2),
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        unselectedWidgetColor: fideuramGreyGalleryt001
    );
  }

  static const _appBarTheme = AppBarTheme(
      elevation: 0,
      // backgroundColor: backgroundGrey,
      foregroundColor: backgroundGrey,
      centerTitle: true,
      color: backgroundGrey
  );


  static final stylePrimaryGreenButton = ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: AppTheme.white);

  static final stylePrimaryGreyButton = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.backgroundGrey,
    foregroundColor: AppTheme.white,
  );

  static final smallElevatedGreenButtonTheme =
  ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: AppTheme.white,
    minimumSize: const Size(107, 32),
    maximumSize: const Size(107, 32),
  );

  static final smallElevatedGreyButtonTheme =
  ElevatedButton.styleFrom(
    backgroundColor: AppTheme.backgroundGrey,
    foregroundColor: AppTheme.white,
    minimumSize: const Size(107, 32),
    maximumSize: const Size(107, 32),

  );

  static final _outlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppTheme.white,
      foregroundColor: AppTheme.primaryColor,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(200.0, 48.0),
      shape: _buttonCornerRadius,
      textStyle: TextStyles.semiBoldPrimary10,
      // padding: const EdgeInsets.all(16.0),
      elevation: 1.0,
      // shadowColor: AppTheme.backgroundGrey,
    ),
  );


  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accentColor,
      foregroundColor: AppTheme.primaryColor,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(200.0, 48.0),
      shape: _buttonCornerRadius,
      textStyle: TextStyles.semiBoldPrimary12,
      // padding: const EdgeInsets.all(16.0),
      elevation: 1.0,
      shadowColor: AppTheme.backgroundGrey,
    ),
  );

  static const _floatingActionButton = FloatingActionButtonThemeData(
      backgroundColor: AppTheme.white,
      foregroundColor: AppTheme.primaryColor,
      elevation: 2.0,
    // ),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: ElevatedButton.styleFrom(
      // backgroundColor: AppTheme.accentColourOrange,
      foregroundColor: AppTheme.primaryColor,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      // minimumSize: const Size(200.0, 48.0),
      // shape: _buttonCornerRadius,
      textStyle: TextStyles.semiBoldAccent12
      // padding: const EdgeInsets.all(16.0),
      // elevation: 1.0,
      // shadowColor: AppTheme.backgroundGrey,
    ),
  );

  static const _buttonCornerRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );

  static final boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.30),
    offset: const Offset(0, 2),
    blurRadius: 7,
    spreadRadius: 0,
  );


}
