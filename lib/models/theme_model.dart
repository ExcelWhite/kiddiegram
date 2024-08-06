import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kiddiegram/constants.dart';

class ThemeModel{
  final String name;
  final Color primaryTextColor;
  final Color primaryFieldColor;
  final Color primaryButtonColor;
  final Color backgroundBlendColor;
  final Color backgroundColor1;
  final Color backgroundColor2;
  final String backgroundImageUrl;

  ThemeModel({
    required this.name,
    required this.primaryTextColor,
    required this.primaryFieldColor,
    required this.primaryButtonColor,
    required this.backgroundBlendColor,
    required this.backgroundColor1,
    required this.backgroundColor2,
    required this.backgroundImageUrl,
  });

  ThemeData getTheme() {
    var outlineInputBorder = OutlineInputBorder(
          borderSide: BorderSide(color: primaryFieldColor),
          borderRadius: BorderRadius.circular(30),
        );
    var errorInputBorder = OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error_red),
          borderRadius: BorderRadius.circular(30),
        );

    return ThemeData(
      primaryColor: primaryTextColor,
      
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.transparent,
        foregroundColor: primaryTextColor

      ),

      textTheme: TextTheme(
        bodySmall: TextStyle(color: primaryTextColor),
        bodyMedium: TextStyle(color: primaryTextColor),
        bodyLarge: TextStyle(color: primaryTextColor),
        titleSmall: TextStyle(color: primaryTextColor),
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: primaryTextColor),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: errorInputBorder,
        prefixIconColor: primaryTextColor,
        hintStyle: TextStyle(color: primaryTextColor)
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryFieldColor,
        unselectedItemColor: primaryTextColor,
        selectedItemColor: primaryTextColor,
        enableFeedback: false,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 24),
      ),

      iconTheme: IconThemeData(
        color: primaryTextColor,
      ),
      dividerTheme: DividerThemeData(color: primaryFieldColor),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryTextColor,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: primaryFieldColor,
        contentTextStyle: TextStyle(
          color: primaryTextColor,
          fontWeight: FontWeight.bold,
        )
      ),

    );
  }
}