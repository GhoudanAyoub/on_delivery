import 'package:flutter/material.dart';
import 'package:on_delivery/home/base.dart';

class Success extends StatefulWidget {
  static String routeName = "/success";
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  String success = 'assets/images/success.gif';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(success),
                  height: 150.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Successful !!',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF303030),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              "Your payment was done successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFF808080),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(vertical: 16),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.green,
              textColor: Colors.white,
              highlightColor: Colors.transparent,
              onPressed: () => Navigator.pushNamed(context, Base.routeName),
              child: Text('Ok'.toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
