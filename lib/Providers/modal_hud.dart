
import 'package:flutter/cupertino.dart';

class ModalHud extends ChangeNotifier
{
  bool isChange = false ;
  changeIsLoading(bool value)
  {
    isChange=value;
    print('Value $isChange');
    notifyListeners();
  }
}