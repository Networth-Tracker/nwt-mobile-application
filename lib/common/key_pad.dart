import 'package:flutter/material.dart';

class KeyPad extends StatefulWidget {
  const KeyPad({super.key});

  @override
  State<KeyPad> createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            KeyPadButton(text: 1),
            KeyPadButton(text: 2),
            KeyPadButton(text: 3),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            KeyPadButton(text: 4),
            KeyPadButton(text: 5),
            KeyPadButton(text: 6),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            KeyPadButton(text: 7),
            KeyPadButton(text: 8),
            KeyPadButton(text: 9),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            KeyPadButton(text: 0, isBlank: true),
            KeyPadButton(text: 0),
            KeyPadButton(text: 0, isBackSpace: true),
          ],
        ),
      ],
    );
  }
}

class KeyPadButton extends StatelessWidget {
  const KeyPadButton({super.key, required this.text, this.isBackSpace = false, this.isBlank = false});

  final int text;
  final bool isBackSpace;
  final bool isBlank;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: isBlank ? Colors.transparent : Color.fromRGBO(249, 250, 251, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: isBackSpace ? Icon(Icons.backspace, size: 20,) : Text(
           isBlank ? "" : text.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
