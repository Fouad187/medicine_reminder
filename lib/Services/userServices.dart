import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicine_reminder/Models/medicine_model.dart';

class UserServices
{
  static Future<void> addNewMedicine({required Medicine medicine}) async
  {
    await FirebaseFirestore.instance.collection('Medicine').doc().set(medicine.toJson());
  }
  static Future<List<Medicine>> getMyMedicine({required String userId}) async
  {
    List<Medicine> medicines=[];

    await FirebaseFirestore.instance.collection('Medicine').where('userId' , isEqualTo: userId).get().then((value){
      for(int i=0 ; i<value.docs.length ; i++)
      {
        medicines.add(Medicine.fromJson(value.docs[i].data()));
        medicines[i].docId=value.docs[i].id;
      }
    });
    return medicines;
  }
}