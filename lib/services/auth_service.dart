import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:on_delivery/services/services.dart';
import 'package:on_delivery/utils/firebase.dart';

import '../models/agent_trips_location.dart';

class AuthService extends Service {
  User getCurrentUser() {
    User user = firebaseAuth.currentUser;
    return user;
  }

  Future<bool> createUser({
    String email,
    String password,
  }) async {
    var res = await firebaseAuth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      await saveUserToFireStore(res.user, email, password);
      return true;
    } else {
      return false;
    }
  }

  static Future addUsers(User user) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (!snapShot.exists) {
        usersRef.doc(user.uid).set({
          'id': user.uid,
          'email': user.email,
          'pass': "",
          'photoUrl': user.photoURL ?? '',
          'firstName': user.displayName,
          'lastName': "",
          'city': "",
          'phone': "",
          'type': '',
          'verificationType': "",
          'side1PhotoUrl': "",
          'side2PhotoUrl': "",
          'passportPhotoUrl': "",
          'activities': "",
          'businessType': "",
          'businessName': "",
          'transportType': "",
          'wareHouse': "",
          'wareHouseAddress': "",
          'wareHousePosition': null,
          'agentTripsLocationList': null,
          'unity': '',
          'maxWeight': '',
          'RIB': "",
          'bankName': "",
        });
      }
    }
    return user.uid;
  }

  saveUserToFireStore(User user, String email, String password) async {
    final snapShot = await usersRef.doc(user.uid).get();
    if (!snapShot.exists) {
      await usersRef.doc(user.uid).set({
        'id': user.uid,
        'email': email,
        'pass': password,
        'photoUrl': "",
        'firstName': "",
        'lastName': "",
        'city': "",
        'phone': "",
        'type': '',
        'verificationType': "",
        'side1PhotoUrl': "",
        'side2PhotoUrl': "",
        'passportPhotoUrl': "",
        'activities': "",
        'businessType': "",
        'businessName': "",
        'transportType': "",
        'wareHouse': "",
        'wareHouseAddress': "",
        'wareHousePosition': null,
        'agentTripsLocationList': null,
        'unity': '',
        'maxWeight': '',
        'RIB': "",
        'bankName': "",
      });
    }
  }

  updateUserTypeToFireStore(User user, String type) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({'type': type});
      }
    }
  }

  updateTripsmaxWeightToFireStore(User user, String maxWeight) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'maxWeight': maxWeight,
        });
      }
    }
  }

  updateTripsLocationToFireStore(
      User user, List<AgentTripsLocation> agentTripsLocationList) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'agentTripsLocationList': agentTripsLocationList,
        });
      }
    }
  }

  updateRIBToFireStore(User user, String RIB, String bankName) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'RIB': RIB,
          'bankName': bankName,
        });
      }
    }
  }

  updateActivitiesToFireStore(User user, String activities) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'activities': activities,
        });
      }
    }
  }

  updateBusinessLocationToFireStore(
      User user, String wareHouseAddress, Position wareHousePosition) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'wareHouseAddress': wareHouseAddress,
          'wareHousePosition': wareHousePosition,
        });
      }
    }
  }

  updateUserDataToFireStore(User user, String fName, String lName, String city,
      String phone, File image) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        if (image != null) {
          await uploadImage(profilePic, image)
              .then((value) => usersRef.doc(user.uid).update({
                    'firstName': fName,
                    'lastName': lName,
                    'city': city,
                    'phone': phone,
                    'photoUrl': value
                  }));
        } else
          await usersRef.doc(user.uid).update({
            'firstName': fName,
            'lastName': lName,
            'city': city,
            'phone': phone,
            'photoUrl': firebaseAuth.currentUser.photoURL
          });
      }
    }
  }

  updateVerificationDataToFireStore(User user, String verificationType,
      File side1Image, File side2Image, File passport) async {
    final snapShot = await usersRef.doc(user.uid).get();
    if (snapShot.exists) {
      if (user != null) {
        usersRef.doc(user.uid).update({
          'verificationType': verificationType,
        });
        if (side1Image != null) {
          await uploadImage(identityPic, side1Image)
              .then((value) => usersRef.doc(user.uid).update({
                    'side1PhotoUrl': value,
                  }));
        }
        if (side2Image != null) {
          await uploadImage(identityPic, side2Image)
              .then((value) => usersRef.doc(user.uid).update({
                    'side2PhotoUrl': value,
                  }));
        }
        if (passport != null) {
          await uploadImage(passportPic, passport)
              .then((value) => usersRef.doc(user.uid).update({
                    'passportPhotoUrl': value,
                  }));
        }
      }
    }
  }

  updateBusinessDataToFireStore(
    User user,
    String businessType,
    String businessName,
    String transportType,
    String wareHouse,
  ) async {
    if (user != null) {
      final snapShot = await usersRef.doc(user.uid).get();
      if (snapShot.exists) {
        usersRef.doc(user.uid).update({
          'businessType': businessType,
          'businessName': businessName,
          'transportType': transportType,
          'wareHouse': wareHouse,
        });
      }
    }
  }

  Future<String> loginUser({String email, String password}) async {
    var result;
    var errorType;
    try {
      result = await firebaseAuth.signInWithEmailAndPassword(
        email: '$email',
        password: '$password',
      );
    } catch (e) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          errorType = "No Account For This Email";
          break;
        case 'The password is invalid or the user does not have a password.':
          errorType = "Password Invalid";
          break;
        case 'A network error (interrupted connection or unreachable host) has occurred.':
          errorType = "Connection Error";
          break;
        // ...
        default:
          print('Case ${errorType} is not yet implemented');
      }
    }
    if (errorType != null) return errorType;
    return result.user.uid;
  }

  forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  logOut() async {
    await firebaseAuth.signOut();
  }

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {
      return "Password is too weak";
    } else if (e.contains("invalid-email")) {
      return "Invalid Email";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE") ||
        e.contains('email-already-in-use')) {
      return "The email address is already in use by another account.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
      return "Network error occured!";
    } else if (e.contains("ERROR_USER_NOT_FOUND") ||
        e.contains('firebase_auth/user-not-found')) {
      return "Invalid credentials.";
    } else if (e.contains("ERROR_WRONG_PASSWORD") ||
        e.contains('wrong-password')) {
      return "Invalid credentials.";
    } else if (e.contains('firebase_auth/requires-recent-login')) {
      return 'This operation is sensitive and requires recent authentication.'
          ' Log in again before retrying this request.';
    } else {
      return e;
    }
  }
}
