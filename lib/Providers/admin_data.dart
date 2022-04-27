import 'package:flutter/cupertino.dart';
import 'package:medicine_reminder/Services/adminServices.dart';

import '../Models/user.dart';

class AdminData extends ChangeNotifier
{
  UserModel? user;
  List<UserModel> users=[];
  setUser(UserModel user)
  {
    this.user=user;
  }
  getUsers()
  {
    AdminServices.getAllUsers().then((value) {
      users=value;
      notifyListeners();
    });
  }
  removeFromUsers(int index)
  {
    users.removeAt(index);
    notifyListeners();
  }
}