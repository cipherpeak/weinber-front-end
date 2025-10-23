import 'package:flutter/material.dart';

import 'constants.dart';

//TODO : Change the color and font when constant colors are set up

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryBackgroundColor,
  splashColor: primaryBackgroundColor.withValues(alpha: 0.3),
  highlightColor: primaryBackgroundColor.withValues(alpha: 0.3),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryBackgroundColor),
  // fontFamily: 'TTNorms',
  scaffoldBackgroundColor: primaryBackgroundColor,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      // fontFamily: 'TTNorms',
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: primaryBackgroundColor,
    ),
    elevation: 0,
    leadingWidth: 63,
    centerTitle: false,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(40, 40),
      foregroundColor: Colors.white,
      backgroundColor: primaryBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
    ).copyWith(elevation: const WidgetStatePropertyAll(0)),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom().copyWith(
      foregroundColor: const WidgetStateColor.fromMap({
        WidgetState.disabled: Colors.grey,
        WidgetState.any: primaryBackgroundColor,
      }),
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    fillColor: WidgetStateColor.fromMap({
      WidgetState.selected: primaryBackgroundColor,
      WidgetState.any: Colors.transparent,
    }),
    shape: RoundedRectangleBorder(),
    side: BorderSide(color: primaryBackgroundColor, width: 2),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryBackgroundColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryBackgroundColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryBackgroundColor),
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
      WidgetState.selected: primaryBackgroundColor,
      WidgetState.disabled: primaryBackgroundColor,
      WidgetState.error: Colors.red,
      WidgetState.hovered & WidgetState.focused: primaryBackgroundColor,
      WidgetState.focused: primaryBackgroundColor,
      ~WidgetState.disabled: primaryBackgroundColor,
    }),
    trackColor: WidgetStateProperty.fromMap({
      WidgetState.selected: primaryBackgroundColor,
      WidgetState.disabled: primaryBackgroundColor.withValues(alpha: 0.5),
      ~WidgetState.disabled: primaryBackgroundColor.withValues(alpha: 0.5),
    }),
  ),
);
