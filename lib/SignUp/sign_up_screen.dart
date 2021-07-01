import 'package:flutter/material.dart';
import 'package:on_delivery/utils/SizeConfig.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: Padding(
            padding: EdgeInsets.only(right: 30, top: 40),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
              onPressed: () => Navigator.of(context).pop(),
            )),
        title: Padding(
          padding: EdgeInsets.only(right: 30, top: 40),
          child: Align(
            alignment: Alignment.topRight,
            child: Text("Sign up",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          ),
        ),
      ),
      body: new WillPopScope(
        onWillPop: () async => false,
        child: Body(),
      ),
    ));
  }
}
