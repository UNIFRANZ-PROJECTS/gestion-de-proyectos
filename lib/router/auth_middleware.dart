import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gestion_projects/services/auth_service.dart';
import 'package:qlevar_router/qlevar_router.dart';

class AuthMiddleware extends QMiddleware {
  final authService = Get.find<AuthService>();
  @override
  Future<String?> redirectGuard(String path) async {
    debugPrint('****************************************************************');
    debugPrint('**************************************************************');
    debugPrint('************************************************************');
    debugPrint('VERIFICANDO LOGUEADO**** ${authService.isAuth}');
    if (authService.isAuth) {
      return null;
    }
    return '/login';
  }
}
