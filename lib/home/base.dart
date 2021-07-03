import 'package:flutter/material.dart';
import 'package:on_delivery/block/navigation_block/sidebarlayout.dart';

class Base extends StatefulWidget {
  static String routeName = "/base";
  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: SideBarLayout(),
    );
  }
}
