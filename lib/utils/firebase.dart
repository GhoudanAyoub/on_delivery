import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;
final Uuid uuid = Uuid();

String favoritesName = "onDeliveryFavorites";

// Collection refs
CollectionReference paymentRef = firestore.collection('onDeliveryPayment');
CollectionReference reportRef = firestore.collection('onDeliveryReport');
CollectionReference usersRef = firestore.collection('onDeliveryUsers');
CollectionReference orderRef = firestore.collection('onDeliveryOrders');
CollectionReference favoriteRef = firestore.collection('onDeliveryFavorites');
CollectionReference plansRef = firestore.collection('onDeliveryPlans');
CollectionReference chatRef = firestore.collection("onDeliveryChats");
CollectionReference notificationRef =
    firestore.collection('onDeliveryNotifications');
CollectionReference killAppRef = firestore.collection('kilApp');

// Storage refs
Reference profilePic = storage.ref().child('onDeliveryProfilePic');
Reference passportPic = storage.ref().child('onDeliveryPassportPic');
Reference identityPic = storage.ref().child('onDeliveryIdentityPic');
Reference posts = storage.ref().child('posts');
Reference videos = storage.ref().child('videos');
