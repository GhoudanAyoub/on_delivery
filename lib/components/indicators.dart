import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Center circularProgress(context) {
  return Center(
    child: SpinKitFadingCircle(
      size: 40.0,
      color: Colors.green,
    ),
  );
}

Container linearProgress(context) {
  return Container(
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
    ),
  );
}
