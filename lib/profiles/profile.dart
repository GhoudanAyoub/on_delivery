import 'package:flutter/material.dart';

import '../block/navigation_block/navigation_block.dart';

class Profile extends StatefulWidget with NavigationStates {
  static String routeName = "/home";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Center(child: Text('Profile')),
      ),
    ));
  }
}
