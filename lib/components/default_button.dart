import 'package:flutter/material.dart';
import 'package:on_delivery/utils/SizeConfig.dart';
import 'package:on_delivery/utils/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({Key? key, this.text, required this.press, this.submitted})
      : super(key: key);
  final String? text;
  final VoidCallback press;
  final submitted;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: kPrimaryColor,
          onSurface: Colors.grey[400]??Colors.grey,
        ),
        onPressed: press,
        child: submitted
            ? SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          text??"",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
