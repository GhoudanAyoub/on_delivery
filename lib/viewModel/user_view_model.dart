import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/utils/firebase.dart';

class UserViewModel extends ChangeNotifier {
  late User user;
  late String type;
  FirebaseAuth auth = FirebaseAuth.instance;

  setUser() {
    user = auth.currentUser;
    //notifyListeners();
  }

  setType() async {
    if (auth.currentUser != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        UserModel userModel = UserModel.fromJson(snapShot.data());
        type = userModel.type;
      }
    }
  }
}
