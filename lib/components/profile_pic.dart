import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final Widget child;
  const ProfilePic({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/edit profile.png",
              height: 35,
            ),
          )
        ],
      ),
    );
  }
}
