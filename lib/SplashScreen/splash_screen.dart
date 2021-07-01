import 'package:flutter/material.dart';
import 'package:on_delivery/utils/SizeConfig.dart';

import 'components/body.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: new WillPopScope(
        onWillPop: () async => false,
        child: Body(),
      ),
    );
  }
}
