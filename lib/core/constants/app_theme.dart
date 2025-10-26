import 'package:flutter/material.dart';

import 'constants.dart';

//TODO : Change the color and font when constant colors are set up

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryBackgroundColor,
  splashColor: primaryBackgroundColor.withValues(alpha: 0.3),
  highlightColor: primaryBackgroundColor.withValues(alpha: 0.3),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryBackgroundColor),
  fontFamily: 'Gotham',
  scaffoldBackgroundColor: primaryBackgroundColor,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: primaryColor,
    ),
    elevation: 0,
    leadingWidth: 63,
    centerTitle: false,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(40, 40),
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      textStyle: const TextStyle(
        fontFamily: 'Gotham',
        fontWeight: FontWeight.w700,
      ),
    ).copyWith(elevation: const WidgetStatePropertyAll(0)),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom().copyWith(
      foregroundColor: const WidgetStateColor.fromMap({
        WidgetState.disabled: Colors.grey,
        WidgetState.any: primaryColor,
      }),
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    fillColor: WidgetStateColor.fromMap({
      WidgetState.selected: primaryColor,
      WidgetState.any: Colors.transparent,
    }),
    shape: RoundedRectangleBorder(),
    side: BorderSide(color: primaryColor, width: 2),
  ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      // ✅Default border (grey)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
      ),

      //  Focused border (blue outline)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.6,
        ),
      ),

      //  Disabled border
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),

      //  Error border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),

      //  When focused + error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),

      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 13,
        fontFamily: 'Gotham',
      ),
      prefixIconConstraints: BoxConstraints.tight(const Size.square(43)),
    ),
  switchTheme: SwitchThemeData(
    trackOutlineWidth: const WidgetStatePropertyAll(0.0),
    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    thumbIcon: const WidgetStatePropertyAll(
      Icon(IconData(0), color: Colors.transparent),
    ),
    thumbColor: WidgetStateProperty.fromMap({
      WidgetState.selected: primaryColor,
      WidgetState.disabled: primaryBackgroundColor,
      WidgetState.error: Colors.red,
      WidgetState.hovered & WidgetState.focused: primaryColor,
      WidgetState.focused: primaryColor,
      ~WidgetState.disabled: primaryBackgroundColor,
    }),
    trackColor: WidgetStateProperty.fromMap({
      WidgetState.selected: primaryColor,
      WidgetState.disabled: primaryColor.withValues(alpha: 0.5),
      ~WidgetState.disabled: primaryColor.withValues(alpha: 0.5),
    }),
  ),
);
