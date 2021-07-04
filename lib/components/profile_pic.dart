import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final Widget child;
  const ProfilePic({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          child,
          Positioned(
            right: -20,
            bottom: -40,
            child: Image.asset(
              "assets/images/edit profile.png",
              height: 80,
            ),
          )
        ],
      ),
    );
  }
}
