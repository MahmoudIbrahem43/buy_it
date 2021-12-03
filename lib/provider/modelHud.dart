import 'package:flutter/material.dart';

class ModelHud extends ChangeNotifier {
  bool isLoading = false;
  changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners(); //like set state .. reBuild screen
  }
}
