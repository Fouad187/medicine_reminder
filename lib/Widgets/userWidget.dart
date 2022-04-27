import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/Models/user.dart';
import 'package:medicine_reminder/Providers/admin_data.dart';
import 'package:provider/provider.dart';

class UserWidget extends StatelessWidget {
  UserModel user;
  int index;
  UserWidget({required this.user , required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name : ${user.name}', style: TextStyle(fontWeight: FontWeight.w600),),
                Text('Email : ${user.email}', style: TextStyle(fontWeight: FontWeight.w600),),
              ],
            ),
            SizedBox(height: 15,),
            Text('User Id : ${user.id}', style: TextStyle(fontWeight: FontWeight.w600),),
            SizedBox(height: 10,),
            Text('Type : ${user.type}', style: TextStyle(fontWeight: FontWeight.w600),),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: 250,
                child: MaterialButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('Users').doc(user.id).delete().then((value)
                    {
                      Provider.of<AdminData>(context,listen:false).removeFromUsers(index);
                    });
                  }, child: const Text('Remove From App' , style: TextStyle(color: Colors.white),),
                color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
