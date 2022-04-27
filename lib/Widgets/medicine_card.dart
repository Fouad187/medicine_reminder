import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_reminder/Providers/user_data.dart';
import 'package:provider/provider.dart';

import '../Models/medicine_model.dart';

class MedicineCard extends StatelessWidget {
  Medicine medicine;
  int index;
  MedicineCard({required this.medicine , required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                      width: double.infinity,
                      height: 120,
                      child: Image(image: AssetImage('assets/images/${medicine.medicineType}'))),
                ),
                Divider(),
                SizedBox(height: 10,),
                Text(medicine.medicineName , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey , fontSize: 18),),
                SizedBox(height: 8,),
                Text('${(24/medicine.interval).floor()} Time Per Day'),
              ],
            ),
             Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                    onTap: () async {
                      await FirebaseFirestore.instance.collection('Medicine').doc(medicine.docId).delete().then((value) async {
                        FlutterLocalNotificationsPlugin flutterNotification=FlutterLocalNotificationsPlugin();
                        for (int i=0 ; i<medicine.notificationIDs.length ; i++)
                        {
                          await flutterNotification.cancel(int.parse(medicine.notificationIDs[i]));
                        }
                        Provider.of<UserData>(context,listen: false).removeFromMedicine(index);
                      });

                    },
                    child: const Icon(Icons.delete , color: Colors.red,))),
          ],
        )
      ),
    );
  }
}
