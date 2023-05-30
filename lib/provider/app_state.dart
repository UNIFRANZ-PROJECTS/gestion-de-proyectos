import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class AppState extends ChangeNotifier {
  String selectedCategoryId = 'todos';

  void updateCategoryId(String selectedCategoryId) {
    this.selectedCategoryId = selectedCategoryId;
    notifyListeners();
  }
}

class AuthData extends ChangeNotifier {
  AuthModel? authData;

  void updateAuth(AuthModel data) {
    authData = data;
    notifyListeners();
  }
}
