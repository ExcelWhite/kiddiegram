import 'package:flutter/foundation.dart';
import 'package:kiddiegram/constants.dart';
import 'package:kiddiegram/models/theme_model.dart';

class ThemeProvider with ChangeNotifier{
  final List<ThemeModel> _themes = [
    ThemeModel(
      name: 'light',
      primaryTextColor: AppColors.light_theme_red,
      primaryFieldColor: AppColors.light_theme_milk,
      primaryButtonColor: AppColors.light_theme_blue,
      backgroundBlendColor: AppColors.light_theme_lavender,
      backgroundColor1: AppColors.light_theme_green,
      backgroundColor2: AppColors.light_theme_peach,
      backgroundImageUrl: 'assets/images/light_theme_bg.png',
    ),
    ThemeModel(
      name: 'dark',
      primaryTextColor: AppColors.dark_theme_sky_blue,
      primaryFieldColor: AppColors.dark_theme_purple,
      primaryButtonColor: AppColors.dark_theme_green,
      backgroundBlendColor: AppColors.dark_theme_pink,
      backgroundColor1: AppColors.dark_theme_orange,
      backgroundColor2: AppColors.dark_theme_blue,
      backgroundImageUrl: 'assets/images/dark_theme_bg.png',
    ),
    ThemeModel(
      name: 'orange_season',
      primaryTextColor: AppColors.orange_season_theme_white,
      primaryFieldColor: AppColors.orange_season_theme_red,
      primaryButtonColor: AppColors.orange_season_theme_blue,
      backgroundBlendColor: AppColors.orange_season_theme_orange,
      backgroundColor1: AppColors.orange_season_theme_yellow,
      backgroundColor2: AppColors.orange_season_theme_sky_pink,
      backgroundImageUrl: 'assets/images/mango_season_bg.png',
    ),
  ];

  int _currentIndex = 0;

  ThemeModel get currentTheme => _themes[_currentIndex];

  List<ThemeModel> get themes => _themes;

  void changeTheme(int index){
    _currentIndex = index;
    notifyListeners();
  }
}