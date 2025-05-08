import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwt_app/services/global_storage.dart';

class ThemeController extends GetxController {
  // Observable variable for dark mode state
  final RxBool _isDarkMode = false.obs;
  
  // Key for storing theme preference
  static const String _themeKey = 'is_dark_mode';

  // Getter for isDarkMode
  bool get isDarkMode => _isDarkMode.value;
  
  // ThemeMode getter based on isDarkMode
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  // Load saved theme preference from storage
  Future<void> _loadThemeFromStorage() async {
    final savedTheme = StorageService.read(_themeKey);
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme as bool;
    }
  }

  // Toggle theme between light and dark
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _saveThemeToStorage();
    Get.changeThemeMode(themeMode);
    update();
  }

  // Set theme explicitly (light or dark)
  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _saveThemeToStorage();
    Get.changeThemeMode(themeMode);
  }

  // Save theme preference to storage
  Future<void> _saveThemeToStorage() async {
    StorageService.write(_themeKey, _isDarkMode.value);
  }
}
