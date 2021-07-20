import 'package:flutter/material.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
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
            child: Text("Forget Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.grey.withOpacity(0),
                ]),
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Body()),
    ));
  }
}
