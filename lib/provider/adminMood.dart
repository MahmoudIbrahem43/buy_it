import 'package:flutter/cupertino.dart';

class AdminMood extends ChangeNotifier{
  bool isAdmin = false;

  changeIsAdmine(value){
    isAdmin=value;
    notifyListeners();
  }
}