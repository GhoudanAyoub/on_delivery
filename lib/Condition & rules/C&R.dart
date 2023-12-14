import 'package:flutter/material.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';

class CR extends StatefulWidget with NavigationStates {
  static String routeName = "/C&R";
  @override
  _CRState createState() => _CRState();
}

class _CRState extends State<CR> {
  String? TEXT =
      "What is What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasLorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it hasWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: Padding(
            padding: EdgeInsets.only(right: 30, top: 40),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Color.fromRGBO(5, 151, 0, 1)),
              onPressed: () => Navigator.of(context).pop(),
            )),
      ),
      body: Container(
          padding: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/images/pg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text("Conditions & Rules",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Color.fromRGBO(248, 250, 251, 1),
                    ),
                    child: Text(
                      TEXT??"",
                      style: TextStyle(letterSpacing: 1, fontSize: 16),
                    ),
                  )
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Colors.grey, Colors.grey],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500]??Colors.grey??Colors.grey,
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          )),
    ));
  }
}
