import 'package:flutter/material.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';

class ProfileBoxData extends StatelessWidget {
  const ProfileBoxData({Key? key, this.LIKES, this.FOLLOWING, this.FOLLOWERS})
      : super(key: key);
  final String? LIKES, FOLLOWING, FOLLOWERS;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: kPrimaryColor,
          onSurface: Colors.grey[400]??Colors.grey,
          padding: EdgeInsets.all(10),
        ),
        onPressed: () {},
        child: Row(
          children: [
            SizedBox(width: getProportionateScreenWidth(30)),
            Column(
              children: [
                Text("LIKES",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      color: kTextColor,
                      fontFamily: "SFProDisplay-Light",
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(
                  width: 10,
                  height: 5,
                ),
                Text(LIKES??"0",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: GBottomNav,
                      fontFamily: "SFProDisplay-Medium",
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(width: getProportionateScreenWidth(30)),
            Column(
              children: [
                Text("FOLLOWING",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      color: kTextColor,
                      fontFamily: "SFProDisplay-Light",
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(
                  width: 10,
                  height: 5,
                ),
                Text(FOLLOWING??"0",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: GBottomNav,
                      fontFamily: "SFProDisplay-Medium",
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            SizedBox(width: getProportionateScreenWidth(30)),
            Column(
              children: [
                Text("FOLLOWERS",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      color: kTextColor,
                      fontFamily: "SFProDisplay-Light",
                      fontWeight: FontWeight.normal,
                    )),
                SizedBox(
                  width: 10,
                  height: 5,
                ),
                Text(FOLLOWERS??"0",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(20),
                      color: GBottomNav,
                      fontFamily: "SFProDisplay-Medium",
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
