import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/rate.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/utils.dart';

class RateLayout extends StatefulWidget {
  final String id;
  final RateModel rateModel;

  const RateLayout({Key? key, this.id, this.rateModel}) : super(key: key);
  @override
  _RateLayoutState createState() => _RateLayoutState();
}

class _RateLayoutState extends State<RateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Color.fromRGBO(248, 250, 251, 1),
      ),
      child: Column(
        children: [
          StreamBuilder(
            stream: usersRef.doc(widget.rateModel.userID).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                UserModel user1 = UserModel.fromJson(snapshot.data.data());

                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromRGBO(248, 250, 251, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Stack(
                              fit: StackFit.passthrough,
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    user1.photoUrl != null
                                        ? user1.photoUrl
                                        : "https://images.unsplash.com/photo-1571741140674-8949ca7df2a7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
                                  ),
                                  radius: 30.0,
                                ),
                                Positioned(
                                  right: -5,
                                  bottom: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    height: 15,
                                    width: 15,
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: user1?.isOnline ?? false
                                              ? Color(0xff00d72f)
                                              : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        height: 11,
                                        width: 11,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: getProportionateScreenWidth(230),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${user1.firstName} ${user1.lastname.toUpperCase()}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                    Text(
                                        "${DateFormat('MMM dd,yyyy').format(Utils.toDateTime(widget.rateModel.timestamp))}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset('assets/images/agent rate.png'),
                                    Text("${widget.rateModel.rate}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("${widget.rateModel.rateTxt} ",
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ],
                  ),
                );
              }
              return Container(
                height: 0,
              );
            },
          )
        ],
      ),
    );
  }
}
