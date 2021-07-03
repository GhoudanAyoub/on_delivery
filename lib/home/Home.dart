import 'package:flutter/material.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';

class Home extends StatefulWidget with NavigationStates {
  static String routeName = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(child: Text("home"))),
    ));
  }
}
