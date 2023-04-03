import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:guanxii_app/constants.dart';
import 'package:guanxii_app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseUtils {
  static Future<String> signup(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
      return 'Error Occured';
    } catch (e) {
      return (e.toString());
    }
  }

  static Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      usermail = email;
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      } else {
        return 'Error Logging In';
      }
    }
  }

  static Future<void> addQR(String key, String path) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection('QRs')
        .add({
          'key': key,
          'path': path,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<String?> getProfileQr(String key) async {
    try {
      String? path;
      await FirebaseFirestore.instance
          .collection('QRs')
          .where('key', isEqualTo: key)
          .get()
          .then((value) async {
        QuerySnapshot<Map<String, dynamic>> qrs = value;
        print('Method Called on ${value.docs[0].data()}');

        for (var item in qrs.docs) {
          path = item.data()['path'];
        }
        return path;
      });
      return path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> addUser(String name, String email, String password) {
    // Call the user's CollectionReference to add a new user
    return FirebaseFirestore.instance
        .collection('users')
        .add({
          'name': name,
          'email': email, // John Doe
          'password': password, // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> get getUser {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: usermail)
        .snapshots();
  }

  static loadAdminData() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: usermail)
          .get()
          .then((value) async {
        QuerySnapshot<Map<String, dynamic>> users = value;
        print('Method Called on ${value.docs[0].data()}');
        for (var item in users.docs) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(userNamekey, item.data()['name']);
          userName = item.data()['name'];
        }
      });
    } catch (e) {
      print('Error');
    }
  }

  static deleteProfile({required DocumentReference docRef}) {
    docRef.delete().then((value) {
      print('-----------------------------------------delete successfully');
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> get getProfiles {
    return FirebaseFirestore.instance
        .collection('Profiles')
        .where('userMail', isEqualTo: usermail)
        .snapshots();
  }

  static void updateProfile(
      {required Profile profile, required DocumentReference docRef}) {
    docRef.update(profile.toMap()).then((docRef) {
      print('-----------------------------------------update successfully');
    });
  }

  static Future<bool> addProfile(Profile profile) {
    // Call the Profile CollectionReference to add a new Profile
    return FirebaseFirestore.instance
        .collection('Profiles')
        .add(profile.toMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  static Future<String> uploadItemImage(File image) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("images/${image.path}");

    TaskSnapshot taskSnapshot = await storageReference.putFile(image);

    var downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  //Reset Password
  Future<String> resetPassword({String? email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email!,
      );
      return "Email sent";
    } catch (e) {
      return "Error occurred";
    }
  }
}
