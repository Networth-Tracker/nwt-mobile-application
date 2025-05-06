import 'package:flutter/material.dart';

InputDecoration primaryInputDecoration(String hintText, {bool isOTP = false}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: isOTP ? 15 : 20,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),

    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
