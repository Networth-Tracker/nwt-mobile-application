import 'package:flutter/material.dart';

class AppColors {
  static final lightTheme = {
    'base': {
      'background': Colors.white,
      'primary': Colors.blue,
      'secondary': Colors.grey,
    },
    'text': {
      'primary': Colors.black,
      'secondary': Color.fromRGBO(70, 71, 72, 1),
      'tertiary': Colors.grey,
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
        'border': Color.fromRGBO(197, 201, 208, 1),
        'text': Color.fromRGBO(70, 71, 72, 1),
      },
      'secondary': {
        'background': Color.fromRGBO(245, 245, 245, 1),
        'border': Colors.white.withValues(alpha: 0.2),
        'text': Color.fromRGBO(70, 71, 72, 1),
      },
    },
  };

  static final darkTheme = {
    'base': {
      'background': Color.fromRGBO(45, 46, 47, 1),
      'primary': Colors.tealAccent,
    },
    'text': {
      'primary': Colors.black,
      'secondary': Colors.grey,
      'tertiary': Colors.grey,
    },
    'button': {
      'primary': {
        "text": Colors.white,
        "background": Color.fromRGBO(45, 55, 119, 1),
        "border": Color.fromRGBO(45, 55, 119, 1),
      },
    },
    'input': {
      'background': Colors.transparent,
      'border': Colors.white.withValues(alpha: 0.2),
      'text': Colors.white,
    },
  };
}
