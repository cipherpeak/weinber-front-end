import 'package:flutter/material.dart';

import 'constants.dart';

//TODO : Change the color and font when constant colors are set up

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryBackgroundColor,
  splashColor: primaryBackgroundColor.withValues(alpha: 0.3),
  highlightColor: primaryBackgroundColor.withValues(alpha: 0.3),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryBackgroundColor),
  fontFamily: 'CroissantOne',
  scaffoldBackgroundColor: primaryBackgroundColor,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'CroissantOne',
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
        fontFamily: 'CroissantOne',
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
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryColor),
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
