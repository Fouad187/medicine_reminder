
import 'package:flutter/material.dart';
import 'package:medicine_reminder/Services/userServices.dart';

import '../Models/medicine_model.dart';
import '../Models/user.dart';

class UserData extends ChangeNotifier
{
  UserModel? user;
  List<Medicine> medicines=[];
  setUser(UserModel user)
  {
    this.user=user;
  }

  Future<void> getMyMedicine() async
  {
    UserServices.getMyMedicine(userId: user!.id).then((value) {
      medicines=value;
      notifyListeners();
    });
  }
  void removeFromMedicine(int index)
  {
    medicines.removeAt(index);
    notifyListeners();
  }


}