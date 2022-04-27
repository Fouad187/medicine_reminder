import 'package:flutter/cupertino.dart';

class AddNewMedicineProvider extends ChangeNotifier
{
  String? timeOfDay;
  int? interval;
  void setTime(String time)
  {
    timeOfDay=time;
    notifyListeners();
  }
  void setInterval(int newInterval)
  {
    interval=newInterval;
    notifyListeners();
  }

}