import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final bool elevated;
  final Color? color;

  CustomCard({
    required this.child,
    required this.onTap,
    required this.borderRadius,
    this.elevated = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: elevated
          ? BoxDecoration(
              borderRadius: borderRadius,
              color: color == null ? Theme.of(context).cardColor : color,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[100]?.withOpacity(0.8) ?? Colors.grey,
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    4.0,
                  ),
                ),
              ],
            )
          : BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).cardColor,
            ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
