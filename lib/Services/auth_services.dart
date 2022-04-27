
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/user.dart';
import '../Providers/modal_hud.dart';
import '../Providers/user_data.dart';
import '../Screens/Home/homeScreen.dart';

class Auth
{
  FirebaseAuth _auth=FirebaseAuth.instance;
  final CollectionReference _userCollection=FirebaseFirestore.instance.collection('Users');

  Future<void> signIn({required String email , required String password ,required context}) async
  {
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      _userCollection.doc(value.user?.uid).get().then((value2) {
        UserModel userModel=UserModel(
          email: (value2)['email'],
          id: value.user!.uid,
          name: (value2)['name'],
        );
       final instance = Provider.of<ModalHud>(context, listen: false);
        Provider.of<UserData>(context , listen: false).setUser(userModel);
        Navigator.pushReplacementNamed(context, HomeScreen.id);
        instance.changeIsLoading(false);
      });
    });
  }
  Future<void> createAccount({required String name, required String email ,required String password,context}) async
  {

    await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user) async {
      UserModel userModel=UserModel(
        id: user.user!.uid,
        name: name,
        email: email,
      );
      await Adduserdata(userModel);
      Provider.of<UserData>(context , listen: false).setUser(userModel);
    });

  }
  Future<void> Adduserdata(UserModel userModel) async
  {
    return await _userCollection.doc(userModel.id).set(userModel.toJson());
  }
  void signOut() async
  {
    await _auth.signOut();
  }


}