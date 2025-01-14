import 'package:flutter/material.dart';

///This Is Class App Theme
class AppTheme {
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      scaffoldBackgroundColor: Colors.white,
      cardColor:  Colors.white,
      inputDecorationTheme: _inputDecorationTheme(Colors.black),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.redAccent),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        Colors.white,
         Color.fromARGB(0, 28, 57, 65),
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red.withOpacity(1.0),
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red.withOpacity(1.0),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor:  Color.fromARGB(255, 242, 104, 77),
        contentTextStyle:  TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      scaffoldBackgroundColor: Colors.black,
      cardColor:  Color.fromARGB(255, 57, 57, 57),
      inputDecorationTheme: _inputDecorationTheme(Colors.white),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.black),
      floatingActionButtonTheme: _floatingActionButtonTheme(
         Color.fromARGB(255, 57, 57, 57),
        Colors.white,
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red.withOpacity(1.0),
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red.withOpacity(1.0),
      ),
    );
  }


  /// Light Color Scheme
  static  ColorScheme _lightColorScheme = ColorScheme(
    primary: Colors.black,
    secondary: Colors.black,
    surface: Colors.white,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Dark Color Scheme
  static  ColorScheme _darkColorScheme = ColorScheme(
    primary: Colors.white,
    secondary: Colors.white,
    surface: Colors.black,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  /// AppBar Theme
  static  AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );

  /// Dark AppBar Theme
  static  AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );

  /// Input Decoration Theme
  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding:  EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  /// Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding:  EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Floating Action Button Theme
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return FloatingActionButtonThemeData(
      shape:  CircleBorder(),
      elevation: 1,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Get Text Theme
  static TextTheme _getTextTheme() {
    final isArabic =  Locale('ar').languageCode == 'ar';
    final fontFamily =
        isArabic ? 'Tajawal' : 'Schyler'; // استخدام Schyler للإنجليزية
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(
          fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(
          fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(
          fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(
          fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.normal),
    );
  }
}
