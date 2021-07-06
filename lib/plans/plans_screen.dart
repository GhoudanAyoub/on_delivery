import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/block/navigation_block/navigation_block.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/models/plans.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/utils.dart';

class Plans extends StatefulWidget with NavigationStates {
  static String routeName = "/plans";
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  bool starter = false, eco = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              SizedBox(height: 60),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Plans",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream:
                      plansRef.doc(firebaseAuth.currentUser.uid).snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.exists) {
                      PlansModel plans =
                          PlansModel.fromJson(snapshot.data.data());
                      if (Utils.getCurrentDate()
                          .isBefore(DateTime.parse(plans.endAt))) {
                        return Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              "You have ${Utils.getCurrentDate().difference(DateTime.parse(plans.endAt))} days left before your finish your free plan. Please try to chose a plan before that.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              )),
                        );
                      }
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                            "Your plan Ends ${Utils.getCurrentDate().difference(DateTime.parse(plans.endAt))} days ago. You are welcomed to replan again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            )),
                      );
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                          "You can choose the plan that works for you, but we recommend the Economical one",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          )),
                    );
                  },
                ),
              ),
              Expanded(
                  child: ListView(
                padding: EdgeInsets.only(left: 40, right: 40, top: 40),
                children: [
                  GestureDetector(
                    child: Card(
                        elevation: starter ? 8 : 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 180,
                          width: 160,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: starter ? Colors.green : Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Starter",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: starter
                                        ? Colors.blueAccent
                                        : Colors.black,
                                  )),
                              Text("70",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              Text("dh/month",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                        )),
                    onTap: () {
                      setState(() {
                        starter = true;
                        eco = false;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    child: SizedBox(
                      height: 180,
                      width: 160,
                      child: Stack(
                        fit: StackFit.expand,
                        overflow: Overflow.visible,
                        children: [
                          Card(
                              elevation: eco ? 8 : 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                height: 180,
                                width: 160,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1,
                                      color: eco ? Colors.green : Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("Economic",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: eco
                                              ? Colors.blueAccent
                                              : Colors.black,
                                        )),
                                    Text("600",
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        )),
                                    Text("dhs/year",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ))
                                  ],
                                ),
                              )),
                          Positioned(
                            top: -20,
                            left: -20,
                            child: Card(
                              elevation: eco ? 8 : 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Container(
                                width: 50,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color.fromRGBO(255, 182, 40, 1),
                                        Color.fromRGBO(238, 71, 0, 1)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[500],
                                        offset: Offset(0.0, 1.5),
                                        blurRadius: 1.5,
                                      ),
                                    ]),
                                child: Center(
                                  child: Text(
                                    '-30%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        starter = false;
                        eco = true;
                      });
                    },
                  )
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    starter || eco
                        ? RaisedGradientButton(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromRGBO(82, 238, 79, 1),
                                Color.fromRGBO(5, 151, 0, 1)
                              ],
                            ),
                            width: SizeConfig.screenWidth - 150,
                            onPressed: () async {})
                        : SizedBox(
                            height: 0,
                          ),
                    SizedBox(height: 20),
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Colors.grey[300], Colors.grey[300]],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
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
