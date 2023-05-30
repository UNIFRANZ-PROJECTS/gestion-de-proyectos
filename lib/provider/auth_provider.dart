import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projects/services/auth_service.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:get/get.dart' as getdart;
import 'package:qlevar_router/qlevar_router.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.checking;

  AuthProvider() {
    isAuthenticated();
  }

  login(Response<dynamic> resp) {
    debugPrint('authResponse.token ${resp.data}');
    authStatus = AuthStatus.authenticated;
    LocalStorage.prefs.setString('token', resp.data['token']);
    LocalStorage.prefs.setString('userData', json.encode(resp.data));
    getdart.Get.find<AuthService>().isAuth = true;
    QR.navigator.replaceLast('/dashboard');

    CafeApi.configureDio();

    notifyListeners();
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');
    if (token != null) {
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    try {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('e $e');
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    getdart.Get.find<AuthService>().isAuth = false;
    LocalStorage.prefs.remove('token');
    QR.navigator.replaceLast('/login');
    notifyListeners();
  }
}
