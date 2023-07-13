import 'package:artb2b/app/resources/styles.dart';
import 'package:flutter/material.dart';
export 'package:flutter/services.dart' show SystemUiOverlayStyle;

class AppTheme {
  const AppTheme._();

  static const primaryColor = primaryColourViolet;
  static const accentColor = accentColourOrange;
  static const backgroundColor = backgroundGrey;
  static const primaryColourViolet = Color(0xFF8E2E8E);
  static const accentColourOrange = Color(0xFFE85F4A);
  static const secondaryColourRed = Color(0xFFA40500);
  static const white = Color(0xFFFFFFFF);
  static const backgroundGrey = Color(0xFFF0F0F0);
  static const black = Color(0xFF0D0D0D);



  static const primaryColorArtist = fideuramGreenArtist001;
  static const fideuramGreenArtist001 = Color(0xB2E3BDFF);
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
      scaffoldBackgroundColor: backgroundColor,
      splashColor: accentColor.withOpacity(0.2),
      highlightColor: accentColor.withOpacity(0.2),
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      unselectedWidgetColor: primaryColor,
      textTheme:  const TextTheme(
          titleMedium: TextStyle(color: accentColor)
      ),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: accentColor
      ),
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
      backgroundColor: AppTheme.primaryColourViolet,
      foregroundColor: AppTheme.white);

  static final stylePrimaryGreyButton = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.backgroundGrey,
    foregroundColor: AppTheme.white,
  );

  static final smallElevatedGreenButtonTheme =
  ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColourViolet,
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



  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accentColourOrange,
      foregroundColor: AppTheme.primaryColourViolet,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const Size(200.0, 48.0),
      shape: _buttonCornerRadius,
      textStyle: TextStyles.regularWhite16,
      padding: const EdgeInsets.all(16.0),
      elevation: 1.0,
      shadowColor: AppTheme.backgroundGrey,
    ),
  );

  static const _buttonCornerRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  );



}
