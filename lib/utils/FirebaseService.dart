import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_delivery/models/User.dart';
import 'package:on_delivery/models/message.dart';
import 'package:on_delivery/models/message_list.dart';
import 'package:on_delivery/models/order.dart';
import 'package:on_delivery/models/plans.dart';
import 'package:on_delivery/utils/firebase.dart';
import 'package:on_delivery/utils/utils.dart';

class FirebaseService {
  static String Client_displayName = FirebaseAuth.instance.currentUser.email;

  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  static void changeStatus(String status) async {
    var snapshots = FirebaseFirestore.instance.collection("Users").snapshots();
    await snapshots.forEach((snapshot) async {
      List<DocumentSnapshot> documents = snapshot.docs;
      for (var document in documents) {
        if (document.data()['email'] == FirebaseAuth.instance.currentUser.email)
          await document.data().update("status", (value) => status);
      }
    });
  }

  // USER DATA
  static Stream<List<MessageList>> getUsers() => FirebaseFirestore.instance
      .collection("Message")
      .doc(FirebaseAuth.instance.currentUser.displayName)
      .collection('users')
      .orderBy(MessageListField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(MessageList.fromJson));

  static Future uploadMessage(
      String sender, final String receiver, String message) async {
    final refMessages = FirebaseFirestore.instance.collection('chats');

    final newMessage = messages(
      sender: sender,
      receiver: receiver,
      urlAvatar: FirebaseAuth.instance.currentUser.photoURL,
      username: FirebaseAuth.instance.currentUser.displayName,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());
  }

  static Stream<List<messages>> getMessages() => FirebaseFirestore.instance
      .collection('chats')
      .orderBy(MessageField.createdAt, descending: true)
      .snapshots()
      .transform(Utils.transformer(messages.fromJson));

  // GET UID
  String getCurrentUID() {
    return _firebaseAuth.currentUser.uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  // GET CURRENT USER name
  String getCurrentUserName() {
    return _firebaseAuth.currentUser.displayName;
  }

  static getProfileImage() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser.photoURL;
    } else {
      return "https://images.unsplash.com/photo-1571741140674-8949ca7df2a7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60";
    }
  }

  // Sign Out
  signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<UserModel> getCurrentUserData() async {
    User user = firebaseAuth.currentUser;
    UserModel userModel;
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      userModel = UserModel.fromJson(snapShot.data());
    }
    return userModel;
  }

  switchCurrentUserType(User user, String type) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({'type': type});
      }
    }
  }

  Future<PlansModel> getCurrentUserPlant() async {
    PlansModel plansModel;
    final snapShot = await plansRef.doc(_firebaseAuth.currentUser.uid).get();
    if (snapShot.exists) {
      plansModel = PlansModel.fromJson(snapShot.data());
    }
    return plansModel;
  }

  addCurrentUserPlant(String sAt, String eAt, String pType) async {
    final snapShot = await plansRef.doc(_firebaseAuth.currentUser.uid).get();
    if (snapShot.exists) {
      plansRef.doc(_firebaseAuth.currentUser.uid).update({
        'startAt': sAt,
        'endAt': eAt,
        'userId': _firebaseAuth.currentUser.uid,
        'planType': pType,
      });
    } else {
      plansRef.doc(_firebaseAuth.currentUser.uid).set({
        'startAt': sAt,
        'endAt': eAt,
        'userId': _firebaseAuth.currentUser.uid,
        'planType': pType,
      });
    }
  }

  Future<String> addOrder(User user, Orders orders) async {
    String docId;
    final doc = orderRef.doc();
    if (user != null) {
      docId = doc.id;
      doc.set(orders.toJson()).onError((error, stackTrace) => print(error));
    }
    return docId;
  }

  updateOrders(User user, Orders orders, String docId) {
    orderRef.doc(docId).update({
      "date": Utils.getCurrentDate(),
      "iceBox": orders.iceBox,
      "brand": orders.brand,
      "transport": orders.transport,
      "maxWeight": orders.maxWeight,
      "numberItem": orders.numberItem,
      "lunchStatus": orders.lunchStatus,
      "status": orders.status,
      "price": orders.price,
      "agentId": orders.agentId,
      "userId": orders.userId,
    }).onError((error, stackTrace) => print(error));
  }

  addToFavorite(User user, UserModel userModel) async {
    if (user != null) {
      favoriteRef.doc().set({
        'clientId': user.uid,
        'agentData': userModel.toJson(),
      }).onError((error, stackTrace) => print(error));
    }
  }

  deleteFromFavorite(User user, String id) async {
    if (user != null) {
      await favoriteRef.doc(id).delete();
    }
  }
}
