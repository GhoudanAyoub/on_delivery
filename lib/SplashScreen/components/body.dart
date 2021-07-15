import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_delivery/SignIn/sign_in_screen.dart';
import 'package:on_delivery/home/base.dart';
import 'package:on_delivery/utils/firebase.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool connect = true;
  @override
  void initState() {
    checkInternet();
    super.initState();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        new Future.delayed(Duration(seconds: 3), () {
          if (firebaseAuth.currentUser != null)
            Navigator.pushNamed(context, Base.routeName);
          else
            Navigator.pushNamed(context, SignInScreen.routeName);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/pg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
          child: Lottie.asset(connect
              ? 'assets/lotties/delivery.json'
              : 'assets/lotties/connection_lost.json')),
    );
  }
}
