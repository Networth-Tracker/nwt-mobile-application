import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingWidget({
    Key? key,
    this.size = 40.0,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}
