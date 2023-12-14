import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final VoidCallback onPressed;
  final bool border;

  const RaisedGradientButton(
      {Key? key,
      required this.child,
      required this.gradient,
      this.width = double.infinity,
      this.height = 50.0,
      this.border = false,
        required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10.0),
          border: border
              ? Border.all(color: Colors.grey)
              : Border.all(color: Colors.white, width: 0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]??Colors.grey??Colors.grey,
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
