import 'package:Paperless_Workflow/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class UserRepository {
  static UserRepository _userRepository;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  factory UserRepository() {
    if (_userRepository == null) {
      _userRepository = UserRepository._createInstance();
    }
    return _userRepository;
  }

  UserRepository._createInstance();

  Future<bool> signInWithCredentials({String email, String password}) async {

    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user.uid != null && authResult.user.uid != '') {
         return true;
      } else {
        return false;
      }
    } catch (e) {
      //  print(e);
      print(e.toString());
      return false;
    }
  }

  Future<bool> onEmalAddressVerified() async{
    try {

      FirebaseUser _user = await _firebaseAuth.currentUser();

      if (_user != null) {
        await _user.reload();
        return _user.isEmailVerified;
      } else {
        return false;
      }

    } catch (e) {
      print(e.toString());
      return false;

    }
  }

  Future<bool> resetPassword(String email ) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('Caught Exception ${e.toString()}');
      return false;
    }
  }


  Future<bool> checkEmailVerification() async {
    try {

      FirebaseUser user = await _firebaseAuth.currentUser();

      if (user != null) {
        if (user.isEmailVerified) {

          return true;

        } else {

          return false;

        }
      }

      return false;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }



  Future<bool> storeNewUser(User user) async {
    DocumentReference document = await _firestore.collection('/users').add({
      'user_id': user.userId,
      'name': user.name,
      'email': user.email,
      'designation': user.designation,
      'phone_no': user.phoneNo,
      'user_role': user.userRole
    });

    if (document.documentID != null) {
      return true;
    } else {
      return false;
    }
  }

  Future signUp(User user) async {

    try {
       AuthResult signedInUser = await _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: user.password);

       if(signedInUser.user.uid != null) {
          await signedInUser.user.sendEmailVerification();
          return await storeNewUser(User(name: user.name, email: user.email, designation: user.designation,phoneNo: user.phoneNo, userId: signedInUser.user.uid, userRole: user.userRole));
       }
    } on PlatformException{
      return false;
    } catch(e) {
      return false;
    }
  }

  Future signOut() async {
    try {
      _firebaseAuth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    return user.uid;
  }

  Future<User> getUserData(String userId) async {
    QuerySnapshot snapshots = await _firestore.collection('/users').where(
      "user_id",
      isEqualTo: userId
    ).getDocuments();



    Map<String, dynamic> firestoreUserData = snapshots.documents[0].data;

    if (firestoreUserData != null) {
      return User(
        userId: firestoreUserData['user_id'],
        name: firestoreUserData['name'],
        email: firestoreUserData['email'],
        phoneNo: firestoreUserData['phone_no'],
        designation: firestoreUserData['designation'],
        userRole: firestoreUserData['user_role']
      );
    } else {
      return User();
    }
  }
}
