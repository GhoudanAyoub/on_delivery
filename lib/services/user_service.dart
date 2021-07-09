import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/services/services.dart';
import 'package:on_delivery/utils/firebase.dart';

class UserService extends Service {
  String currentUid() {
    return firebaseAuth.currentUser.uid;
  }

  setUserStatus(bool isOnline) {
    var user = firebaseAuth.currentUser;
    if (user != null) {
      usersRef
          .doc(user.uid)
          .update({'isOnline': isOnline, 'lastSeen': Timestamp.now()});
    }
  }

  Future<String> getUserType(user) async {
    String type;
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        UserModel userModel = UserModel.fromJson(snapShot.data());
        type = userModel.type;
      }
    }
    return type;
  }
}
