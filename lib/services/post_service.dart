import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:uuid/uuid.dart';

import 'services.dart';

class PostService extends Service {
  String postId = Uuid().v4();
  UserModel user;

  uploadProfilePicture(File image, User user) async {
    String link = await uploadImage(profilePic, image);
    var ref = usersRef.doc(user.uid);
    ref.update({
      "photoUrl": link,
    });
  }

  uploadComment(String username, String comment, String userDp, String userId,
      String postId) async {
    await commentRef.doc(postId).collection("comments").add({
      "username": username,
      "comment": comment,
      "timestamp": Timestamp.now(),
      "userDp": userDp,
      "userId": userId,
    });
  }

  addCommentToNotification(
      String type,
      String commentData,
      String username,
      String userId,
      String postId,
      String mediaUrl,
      String ownerId,
      String userDp) async {
    await notificationRef.doc(ownerId).collection('notifications').add({
      "type": type,
      "commentData": commentData,
      "username": username,
      "userId": userId,
      "userDp": userDp,
      "postId": postId,
      "mediaUrl": mediaUrl,
      "timestamp": Timestamp.now(),
    });
  }

  addLikesToNotification(String type, String username, String userId,
      String postId, String mediaUrl, String ownerId, String userDp) async {
    await notificationRef
        .doc(ownerId)
        .collection('notifications')
        .doc(postId)
        .set({
      "type": type,
      "username": username,
      "userId": firebaseAuth.currentUser.uid,
      "userDp": userDp,
      "postId": postId,
      "mediaUrl": mediaUrl,
      "timestamp": Timestamp.now(),
    });
  }
}
