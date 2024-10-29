import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custfyp/notification.dart';
import 'package:custfyp/services/toast_bar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthServiceProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserModel? _user;

  UserModel? get user => _user;
  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get displayName =>
      (_user?.firstName ?? '') + " " + (_user?.lastName ?? '');

  void _setLoader(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      print(user);
      if (user != null) {
        final userDoc =
            await _firebaseFirestore.collection('users').doc(user.uid).get();

        print(userDoc);

        if (userDoc.exists) {
          print("USER EXISTS");
          _user = UserModel.fromMap(
            userDoc.data() as Map<String, dynamic>,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print("failed to fetch user data:$e");
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoader(true);
    try {
      // Register User in Firebase Auth
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? fcmToken = await FireBaseNotifications.getFCMToken();
      //add user data in FireStore
      if (_userCredential != null) {
        await _firebaseFirestore
            .collection('users')
            .doc(_userCredential!.user?.uid)
            .set({
          'id': _userCredential!.user?.uid,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'fcmToken':fcmToken?? "",
        });
      }
    } on FirebaseAuthException catch (e) {
      ToastService.display(e.message ?? "Something went wrong",
          context: context);
    } on FirebaseException catch (e) {
      ToastService.display(e.message ?? "Something went wrong",
          context: context);
    } catch (e) {
      print("Failed to add user: $e");
      ToastService.display('Something went wrong', context: context);
    } finally {
      _setLoader(false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _setLoader(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fetchUserData();
      updateFcmToken();
    } on FirebaseAuthException catch (e) {
      print(e);
      ToastService.display(e.message ?? "Something went wrong",
          context: context);
    } on FirebaseException catch (e) {
      print(e);
      ToastService.display(e.message ?? "Something went wrong",
          context: context);
    } catch (e) {
      print("Failed to login: $e");
      ToastService.display('Something went wrong', context: context);
    } finally {
      _setLoader(false);
    }
  }

  Future<void> updateUser({
    required String firstName,
    required String lastName,
  }) async {
    _setLoader(true);
    try {
      String? fcmToken = await FireBaseNotifications.getFCMToken();
      if (_user != null) {
        await _firebaseFirestore.collection('users').doc(_user?.id).set({
          'id': _user?.id,
          'firstName': firstName,
          'lastName': lastName,
          'email': _user?.email,
          'fcmToken': fcmToken ?? "",
        });
        await fetchUserData();
      }
    } catch (e) {
      print("Failed to update data: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> signOut() async {
    _setLoader(true);
    try {
      await _firebaseAuth.signOut();
      _userCredential = null;
      _user = null;
      GoogleSignIn().signOut();
    } catch (e) {
      print("Failed to sign out: $e");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoader(true);
    try {
      // await GoogleSignIn().signOut();
      // authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception("User not found");
      }
      // Obtain the details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) {
        throw Exception("User could not be authenticated");
      }
// Creating new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      String? fcmToken = await FireBaseNotifications.getFCMToken();
      _userCredential = await _firebaseAuth.signInWithCredential(credential);

      print("_userCredentials: $_userCredential");

      await _firebaseFirestore
          .collection('users')
          .doc(_userCredential?.user?.uid)
          .set({
        'id': _userCredential?.user?.uid,
        'firstName': googleUser.displayName,
        'lastName': "",
        'email': googleUser.email,
        'fcmToken': fcmToken?? "",
      });

      print(_userCredential);
    } catch (e) {
      print(e);
      print("EXCEPTION ON GOOGLE SIGN IN");
    } finally {
      _setLoader(false);
    }
  }

  Future<void> resetPassword(
      {required String email, required BuildContext context}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("password reset email sent")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:${e.toString()}")));
    }
  }

  Future<void> updateFcmToken()async{
    _setLoader(true);
    try{
      String? fcmToken =await FireBaseNotifications.getFCMToken();
      if(_user!=null)
        {
          await _firebaseFirestore.collection('users').doc(_user?.id).set({
            'id': _user?.id,
            'firstName': _user?.firstName,
            'lastName': _user?.lastName,
            'email':_user?.email,
            'fcmToken':fcmToken ?? _user?.fcmToken
          });
        }
    }
    catch(e){

    }
  }
}
