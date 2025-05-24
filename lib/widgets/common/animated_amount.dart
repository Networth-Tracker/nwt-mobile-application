import 'package:flutter/material.dart';

class AnimatedAmount extends StatelessWidget {
  final bool isAmountVisible;
  final String amount;
  final String hiddenText;
  final Duration duration;
  final TextStyle? style;
  final Offset slideOffset;
  final Curve curve;

  const AnimatedAmount({
    super.key,
    required this.isAmountVisible,
    required this.amount,
    this.hiddenText = '₹•••••',
    this.duration = const Duration(milliseconds: 400),
    this.style,
    this.slideOffset = const Offset(0, 0.2),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(
      color: Colors.white,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: slideOffset,
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: curve,
            )),
            child: child,
          ),
        );
      },
      child: isAmountVisible
          ? Text(
              amount,
              key: const ValueKey('amount_visible'),
              style: style ?? defaultStyle,
              textAlign: TextAlign.left,
            )
          : Text(
              hiddenText,
              key: const ValueKey('amount_hidden'),
              style: style ?? defaultStyle,
              textAlign: TextAlign.left
            ),
    );
  }
}
