import 'package:flutter/material.dart';

class AppColors {
  static final Map<String, Map<String, dynamic>> lightTheme = {
    'base': {
      'background': Colors.white,
      'primary': Colors.blue,
      'secondary': Colors.grey,
    },
    'text': {
      'primary': Colors.black,
      'secondary': const Color.fromRGBO(70, 71, 72, 1),
      'tertiary': Color.fromRGBO(0, 51, 78, 1),
      'muted': Color.fromRGBO(124, 125, 126, 1)
    },
    'button': {
      'primary': {
        "text": Colors.white,
        "background": Colors.black,
        "border": Colors.black,
      },
    },
    'input': {
      'primary': {
        'background': Colors.transparent,
        'border': const Color.fromRGBO(197, 201, 208, 1),
        'text': const Color.fromRGBO(70, 71, 72, 1),
      },
      'secondary': {
        'background': const Color.fromRGBO(245, 245, 245, 1),
        'border': Colors.white.withAlpha(51), // alpha 0.2 of 255 = ~51
        'text': const Color.fromRGBO(70, 71, 72, 1),
      },
    },
  };

  static final Map<String, Map<String, dynamic>> darkTheme = {
    'base': {
      'background': const Color.fromRGBO(45, 46, 47, 1),
      'primary': Colors.tealAccent,
    },
    'text': {
      'primary': Colors.white,
      'secondary': Colors.white,
      'tertiary': Colors.white,
      'muted': Color.fromRGBO(124, 125, 126, 1)

    },
    'button': {
      'primary': {
        "text": Colors.white,
        "background": const Color.fromRGBO(45, 55, 119, 1),
        "border": const Color.fromRGBO(45, 55, 119, 1),
      },
    },
    'input': {
      'background': Colors.transparent,
      'border': Colors.white.withAlpha(51),
      'text': Colors.white,
    },
  };
}
