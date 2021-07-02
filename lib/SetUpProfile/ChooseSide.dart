import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_delivery/SetUpProfile/UpdateProfile.dart';
import 'package:on_delivery/components/RaisedGradientButton.dart';
import 'package:on_delivery/services/auth_service.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';

class ChooseSide extends StatefulWidget {
  static String routeName = "/ChooseSide";
  @override
  _ChooseSideState createState() => _ChooseSideState();
}

class _ChooseSideState extends State<ChooseSide> {
  bool agent = false;
  bool client = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/pg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.all(50),
          child: Stack(
            children: [
              Positioned(
                  top: 100,
                  child: Text(
                    'LOGO',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1,
                        fontSize: 16),
                  )),
              SizedBox(height: 20),
              Positioned(
                  top: 200,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        client = true;
                        agent = false;
                      });
                    },
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 95,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: client
                                    ? [
                                        Color.fromRGBO(82, 238, 79, 1),
                                        Color.fromRGBO(5, 151, 0, 1),
                                      ]
                                    : [
                                        Colors.white,
                                        Colors.white,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500],
                                  offset: Offset(0.0, 1.5),
                                  blurRadius: 1.5,
                                ),
                              ]),
                          width: SizeConfig.screenWidth - 110,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.search_circle,
                                size: 30,
                                color: client
                                    ? Colors.white
                                    : Color.fromRGBO(82, 238, 79, 1),
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Looking for Agent',
                                style: TextStyle(
                                    color: client ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        )),
                  )),
              SizedBox(height: 20),
              Positioned(
                top: 320,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        agent = true;
                        client = false;
                      });
                    },
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          height: 95,
                          width: SizeConfig.screenWidth - 110,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: agent
                                    ? [
                                        Color.fromRGBO(82, 238, 79, 1),
                                        Color.fromRGBO(5, 151, 0, 1),
                                      ]
                                    : [
                                        Colors.white,
                                        Colors.white,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[500],
                                  offset: Offset(0.0, 1.5),
                                  blurRadius: 1.5,
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.person_add,
                                size: 30,
                                color: agent
                                    ? Colors.white
                                    : Color.fromRGBO(82, 238, 79, 1),
                              ),
                              SizedBox(width: 20),
                              Text(
                                'New Agent',
                                style: TextStyle(
                                    color: agent ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
              ),
              SizedBox(height: 20),
              agent || client
                  ? Positioned(
                      bottom: 20,
                      child: RaisedGradientButton(
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
                          width: SizeConfig.screenWidth - 110,
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfiles(
                                        Type: agent,
                                      )),
                            );
                            AuthService().updateUserTypeToFireStore(
                                firebaseAuth.currentUser,
                                agent ? "Agent" : "Client");
                          }),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ),
    ));
  }
}
