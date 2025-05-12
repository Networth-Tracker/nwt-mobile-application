import 'package:flutter/material.dart';
import 'package:nwt_app/constants/colors.dart';
import 'package:nwt_app/widgets/common/text_widget.dart';

class KeyPad extends StatefulWidget {
  final Function(int) onKeyPressed;
  final VoidCallback onBackspace;

  const KeyPad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
  });

  @override
  State createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyPadButton(text: 1, onPressed: () => widget.onKeyPressed(1)),
            KeyPadButton(text: 2, onPressed: () => widget.onKeyPressed(2)),
            KeyPadButton(text: 3, onPressed: () => widget.onKeyPressed(3)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyPadButton(text: 4, onPressed: () => widget.onKeyPressed(4)),
            KeyPadButton(text: 5, onPressed: () => widget.onKeyPressed(5)),
            KeyPadButton(text: 6, onPressed: () => widget.onKeyPressed(6)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyPadButton(text: 7, onPressed: () => widget.onKeyPressed(7)),
            KeyPadButton(text: 8, onPressed: () => widget.onKeyPressed(8)),
            KeyPadButton(text: 9, onPressed: () => widget.onKeyPressed(9)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KeyPadButton(text: 0, isBlank: true, onPressed: () {}),
            KeyPadButton(text: 0, onPressed: () => widget.onKeyPressed(0)),
            KeyPadButton(
              text: 0,
              isBackSpace: true,
              onPressed: widget.onBackspace,
            ),
          ],
        ),
      ],
    );
  }
}

class KeyPadButton extends StatelessWidget {
  final int text;
  final bool isBackSpace;
  final bool isBlank;
  final VoidCallback onPressed;

  const KeyPadButton({
    super.key,
    required this.text,
    this.isBackSpace = false,
    this.isBlank = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: isBlank ? null : onPressed,
        child: Container(
          height: 65,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isBlank 
                ? Colors.transparent
                : isDarkMode 
                    ? AppColors.darkInputBackground
                    : AppColors.lightInputPrimaryBackground,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isBlank ? Colors.transparent : isDarkMode 
                  ? Colors.white.withValues(alpha: 0.1) 
                  : Colors.black.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Center(
            child: isBackSpace
                ? Icon(
                    Icons.backspace,
                    size: 20,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  )
                : isBlank 
                    ? const SizedBox() 
                    : AppText(
                        text.toString(),
                        variant: AppTextVariant.headline5,
                        weight: AppTextWeight.semiBold,
                        colorType: isDarkMode 
                            ? AppTextColorType.primary 
                            : AppTextColorType.tertiary,
                      ),
          ),
        ),
      ),
    );
  }
}
