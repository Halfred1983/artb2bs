import 'package:artb2b/app/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../onboard/view/6_venue_price.dart';
import '../../widgets/custom_slider.dart';
export 'package:flutter/services.dart' show SystemUiOverlayStyle;

class AppTheme {
  const AppTheme._();

  static const backgroundColor = backgroundGrey;
  static const primaryColor = Color(0xFFC9F032);
  static const accentColor = Color(0xFF97B426);


  static const s300 = Color(0xFF97b426);
  static const s50 = Color(0xFFF5F8E9);
  static const s400 = Color(0xFF6a7e1b);
  static const sv300 = Color(0xFF08C826);
  static const s100 = Color(0xFF70DF81);
  static const d200 = Color(0xFFFF715E);
  static const sv50 = Color(0xFFE6FAE9);
  static const wv50 = Color(0xFFFFF8E6);
  static const wv500 = Color(0xFF9C7104);
  static const dv50 = Color(0xFFFFEEEC);
  static const dv400 = Color(0xFFB33B2B);
  static const p400 = Color(0xFF8da823);
  static const n900 = Color(0xFF292730);
  static const n300 = Color(0xFF727076);
  static const n600 = Color(0xFF504E55);
  static const n200 = Color(0xFF8e8c92);
  static const n100 = Color(0xFF8b8a8f);
  static const n500 = Color(0xFF5a5960);
  static const d400 = Color(0xFFb33b2b);
  static const divider = Color(0xFFA8A8A8);
  static const disabledButton = Color(0xFFE3E3E4);






  static const primaryColorOpacity = Color.fromRGBO(201, 240, 50,0.4);
  static const secondaryColourRed = Color(0xFFA40500);
  static const white = Color(0xFFFFFFFF);
  static const backgroundGrey = Color(0xFFF9F9F9);
  static const black = Color(0xFF0D0D0D);
  static const grey = Color(0xFFF9F9F9);





  static ThemeData get theme {
    return ThemeData(
        primaryColor: primaryColor,
        canvasColor: Colors.white,
        cardColor: Colors.white, // Set the background color to white
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
        sliderTheme: SliderThemeData(
          thumbShape: const CustomSliderThumbCircle(thumbRadius: 20, min: 0, max: 1000), // Use the custom slider thumb shape
          showValueIndicator: ShowValueIndicator.always,
          valueIndicatorTextStyle: TextStyles.boldAccent17,
        ),
        segmentedButtonTheme: segmentedButtonStyle
    );
  }

  static const _appBarTheme = AppBarTheme(
      elevation: 0,
      // backgroundColor: backgroundGrey,
      foregroundColor: backgroundGrey,
      centerTitle: true,
      color: backgroundGrey
  );


  // static final stylePrimaryGreenButton = ElevatedButton.styleFrom(
  //     backgroundColor: AppTheme.primaryColor,
  //     foregroundColor: AppTheme.white);

  // static final stylePrimaryGreyButton = ElevatedButton.styleFrom(
  //   backgroundColor: AppTheme.backgroundGrey,
  //   foregroundColor: AppTheme.white,
  // );

  // static final smallElevatedGreenButtonTheme =
  // ElevatedButton.styleFrom(
  //   backgroundColor: AppTheme.primaryColor,
  //   foregroundColor: AppTheme.white,
  //   minimumSize: const Size(107, 32),
  //   maximumSize: const Size(107, 32),
  // );

  // static final smallElevatedGreyButtonTheme =
  // ElevatedButton.styleFrom(
  //   backgroundColor: AppTheme.backgroundGrey,
  //   foregroundColor: AppTheme.white,
  //   minimumSize: const Size(107, 32),
  //   maximumSize: const Size(107, 32),
  //
  // );

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

  static final SegmentedButtonThemeData segmentedButtonStyle = SegmentedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return AppTheme.primaryColor; // Selected color
        }
        return AppTheme.white; // Default color when not selected
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppTheme.n900.withOpacity(0.5); // Disabled text color
        }
        return AppTheme.n900; // Default text color
      }),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: MaterialStateProperty.all(const Size(147.0, 48.0)),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
        return AppTheme._buttonCornerRadius;
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyles.semiBoldN90014; // Disabled text style
        }
        return TextStyles.boldN90014; // Default text style
      }),
      shadowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppTheme.backgroundGrey.withOpacity(0.5); // Disabled shadow color
        }
        return AppTheme.white; // Default shadow color
      }),
      iconSize: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
        return 0.0;
      }),
    ),
  );


  static final _floatingActionButton = FloatingActionButtonThemeData(
      backgroundColor: AppTheme.n900,
      foregroundColor: AppTheme.primaryColor,
      extendedTextStyle: TextStyles.boldPrimary17,
      shape: _buttonCornerRadius,
      elevation: 1.0,
      disabledElevation: 0
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return disabledButton; // Disabled color
        }
        return AppTheme.n900; // Default color
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppTheme.n900; // Disabled text color
        }
        return AppTheme.primaryColor; // Default text color
      }),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: MaterialStateProperty.all(const Size(147.0, 48.0)),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
        return _buttonCornerRadius;
      }),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyles.semiBoldN90014; // Disabled text style
        }
        return TextStyles.semiBoldPrimary14;
      }),
      elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return 0; // No elevation when disabled
        }
        return 1.0; // Default elevation
      }),
      shadowColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppTheme.backgroundGrey.withOpacity(0.5); // Disabled shadow color
        }
        return AppTheme.backgroundGrey; // Default shadow color
      }),
    ),
  );
  static final _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return AppTheme.white.withOpacity(0.5); // Disabled background color
        }
        return AppTheme.white; // Default background color
      }),
      minimumSize: MaterialStateProperty.all( const Size(147.0, 48.0)),
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>((Set<MaterialState> states) {
        return _buttonCornerRadius.copyWith(side: const BorderSide(
          color: AppTheme.p400, // Default border color
          width: 2.0,
        ));
      }),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: MaterialStateProperty.resolveWith<TextStyle>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return TextStyles.semiBoldN90014.copyWith(color: AppTheme.n900.withOpacity(0.5)); // Disabled text style
        }
        return TextStyles.semiBoldN90014; // Default text style
      }),
      elevation: MaterialStateProperty.resolveWith<double>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return 0; // No elevation when disabled
        }
        return 1.0; // Default elevation
      }),
    ),
  );

  static const _buttonCornerRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(50.0)),
  );

  static final boxShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.30),
    offset: const Offset(0, 2),
    blurRadius: 7,
    spreadRadius: 0,
  );

  static final bottomBarShadow = BoxShadow(
    color: Colors.grey.withOpacity(0.30),
    offset: const Offset(0, -10),
    blurRadius: 7,
    spreadRadius: 0,
  );

  static final textInputDecoration = InputDecoration(
    hintText: 'Venue name',
    hintStyle: TextStyles.regularN90014,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0), // Adjust padding to reduce height

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color of the border
        width: 0.5, // Width of the border
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color when the TextField is focused
        width: 0.5, // Width when focused
      ),
    ),
    // Enabled border style
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color when the TextField is enabled
        width: 0.5, // Width when enabled
      ),
    ),
    filled: true,
    fillColor: Colors.white,
  );
  static final textAreaInputDecoration = InputDecoration(
    hintText: 'Venue name',
    hintStyle: TextStyles.regularN90014,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Adjust padding to reduce height

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color of the border
        width: 0.5, // Width of the border
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color when the TextField is focused
        width: 0.5, // Width when focused
      ),
    ),
    // Enabled border style
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppTheme.accentColor, // Color when the TextField is enabled
        width: 0.5, // Width when enabled
      ),
    ),
    filled: true,
    fillColor: Colors.white,
  );

  static const calendarHeaderStyle = HeaderStyle(
      leftChevronIcon: Icon(
        Icons.chevron_left, color: AppTheme
          .n900,),
      rightChevronIcon: Icon(
        Icons.chevron_right, color: AppTheme
          .n900,),
      titleTextStyle: TextStyle(
          fontSize: 17.0, color: AppTheme
          .n900, fontWeight: FontWeight.bold),
      titleCentered: true

  );

  static final calendarStyle = CalendarStyle(
    cellPadding: const EdgeInsets.only(top: 8, bottom: 8),
    // rowDecoration: BoxDecoration(
    //   border: Border.all(width: 0.3, color: Colors.grey), // Add border to each cell
    // ),
    todayTextStyle: const TextStyle(
        color: AppTheme.n900,
        fontWeight: FontWeight.bold),
    selectedTextStyle: const TextStyle(
        color: AppTheme.n900,
    ),
    rangeHighlightColor: AppTheme.primaryColor,
    isTodayHighlighted: true,
    selectedDecoration: const BoxDecoration(
      color: AppTheme.primaryColor,
      shape: BoxShape.circle,
    ),
    todayDecoration: BoxDecoration(
      color: AppTheme.primaryColor.withOpacity(0.4),
      shape: BoxShape.circle,
    ),
    rangeStartDecoration: const BoxDecoration(
      color: AppTheme.accentColor,
      shape: BoxShape.circle,
    ),
    rangeEndDecoration: const BoxDecoration(
      color: AppTheme.accentColor,
      shape: BoxShape.circle,
    ),
    disabledTextStyle: const TextStyle(color: Colors
        .black54,
        decoration: TextDecoration.lineThrough),
  );

  static const quantityProps = QtyDecorationProps(
    minusButtonConstrains: BoxConstraints(minHeight: 50, minWidth: 50),
    plusButtonConstrains: BoxConstraints(minHeight: 50, minWidth: 50),
    plusBtn: PlusMinusButton(text: '+'),
    minusBtn: PlusMinusButton(text: '-'),
    btnColor: AppTheme.accentColor,
    isBordered: false,
    borderShape: BorderShapeBtn.circle,
    width: 54,
  );

  static final numericPriceStyle = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Add padding to center the text
      hintText: '0',
      hintStyle: TextStyles.boldN90029.copyWith(color: AppTheme.n100), // Set the custom hint text style
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppTheme.accentColor, // Color of the border
          width: 0.5, // Width of the border
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppTheme.accentColor, // Color when the TextField is focused
          width: 0.5, // Width when focused
        ),
      ),
      // Enabled border style
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppTheme.accentColor, // Color when the TextField is enabled
          width: 0.5, // Width when enabled
        ),
      )
  );
}
