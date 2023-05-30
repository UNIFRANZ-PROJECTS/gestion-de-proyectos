import 'package:flutter/material.dart';
import 'package:gestion_projects/router/deferred_loader.dart';
import 'package:gestion_projects/services/auth_service.dart';
import 'package:gestion_projects/views/admin/pages/view_404.dart';
import 'package:gestion_projects/views/home/home.dart' deferred as home;
import 'package:gestion_projects/views/login_view.dart' deferred as login;
import 'package:get/get.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'dashboard_routes.dart';

class AppRoutes {
  static const String rootRoute = 'root';
  static const String loginRoute = 'login';

  void setup() {
    // enable debug logging for all routes
    QR.settings.enableDebugLog = true;

    // enable auto restoration for all routes
    QR.settings.autoRestoration = true;

    // you can set your own logger
    // QR.settings.logger = (String message) {
    //   print(message);
    // };

    // Set up the not found route in your app.
    // this route (path and view) will be used when the user navigates to a
    // route that does not exist.
    QR.settings.notFoundPage = QRoute(
      path: 'path',
      builder: () => const View404(),
    );

    // add observers to the app
    // this observer will be called when the user navigates to new route
    QR.observer.onNavigate.add((path, route) async {
      debugPrint('Observer: Navigating to $path');
    });

    // this observer will be called when the popped out from a route
    QR.observer.onPop.add((path, route) async {
      debugPrint('Observer: popping out from $path');
    });

    // create initial route that will be used when the app is started
    // or when route is waiting for response
    //QR.settings.iniPage = InitPage();

    // Change the page transition for all routes in your app.
    QR.settings.pagesType = const QFadePage();
  }

  final routes = <QRoute>[
    QRoute(
        // this will define how to find this route with [QR.to]
        path: '/',
        // this will define how to find this route with [QR.toName]
        name: rootRoute,
        // The page to show when this route is called
        builder: () => home.HomeScreen(),
        middleware: [
          DefferedLoader(home.loadLibrary),
        ]),
    QRoute(
      path: '/login',
      name: loginRoute,
      // What action to perform when this route is called
      // can be defined with classed extends [QMiddleware]
      // or define new one with [QMiddlewareBuilder]
      middleware: [
        DefferedLoader(login.loadLibrary),
        QMiddlewareBuilder(
          redirectGuardFunc: (_) async {
            debugPrint('=====================================================');
            debugPrint('====================================================');
            debugPrint('===================================================');
            debugPrint('VERIFICANDO LOGUEADO');
            // if user is already logged in, redirect to dashboard
            if (Get.find<AuthService>().isAuth) {
              debugPrint('ESTA LOGUEADO');
              return '/dashboard';
            }
            return null;
          },
        )
      ],
      builder: () => login.LoginView(),
    ),
    DashboardRoutes().route,
  ];
}
