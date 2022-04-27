import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_reminder/Models/user.dart';

class AdminServices
{
  static Future<List<UserModel>> getAllUsers() async
  {
    List<UserModel> users=[];
    await FirebaseFirestore.instance.collection('Users').where('type' , isEqualTo: 'User').get().then((value) {
      for(int i=0 ; i<value.docs.length ; i++)
      {
        users.add(UserModel.fromJson(value.docs[i].data()));
      }
    });
    return users;
  }
}