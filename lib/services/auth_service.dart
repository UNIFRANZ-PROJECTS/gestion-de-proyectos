import 'package:gestion_projects/services/local_storage.dart';

class AuthService {
  bool isAuth = LocalStorage.prefs.getString('token') != null ? true : false;
}
