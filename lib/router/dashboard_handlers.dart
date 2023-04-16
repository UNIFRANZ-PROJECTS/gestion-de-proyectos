import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projects/views/admin/dashboard/dashboard_view.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/router/router.dart';
import 'package:gestion_projects/views/admin/permisions/permisions_view.dart';
import 'package:gestion_projects/views/admin/projects/projects_view.dart';
import 'package:gestion_projects/views/admin/roles/roles_view.dart';
import 'package:gestion_projects/views/admin/subjects/subjects_view.dart';
import 'package:gestion_projects/views/admin/teachers/teachers_view.dart';
import 'package:gestion_projects/views/admin/type_users/type_users_view.dart';
import 'package:gestion_projects/views/home/home.dart';
import 'package:provider/provider.dart';
import '../views/admin/users/users_view.dart';

class DashboardHandlers {
  //dashboard
  static Handler dashboard = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.dashboardRoute);
    debugPrint('LLEGUEEEEEEEE');
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const DashboardView();
    } else {
      return const HomeScreen();
    }
    // return HomeScreen();
  });
  // teacher
  static Handler teacher = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.teacherRoute);
    debugPrint('LLEGUEEEEEEEE');
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TeacherView();
    } else {
      return const HomeScreen();
    }
    // return HomeScreen();
  });
  // subject
  static Handler subject = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.subjectRoute);
    debugPrint('LLEGUEEEEEEEE');
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const SubjectView();
    } else {
      return const HomeScreen();
    }
  });
  // project
  static Handler project = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.projectRoute);
    debugPrint('LLEGUEEEEEEEE');
    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const ProjectView();
    } else {
      return const HomeScreen();
    }

    // return HomeScreen();
  });
  // users
  static Handler users = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.usersRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const UsersView();
    } else {
      return const HomeScreen();
    }
  });
  // permisos
  static Handler permisions = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.permisionsRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const PermisionsView();
    } else {
      return const HomeScreen();
    }
  });
  // roles
  static Handler roles = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.rolesRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const RolesView();
    } else {
      return const HomeScreen();
    }
  });
  // tipos de usuarios
  static Handler typeUsers = Handler(handlerFunc: (context, params) {
    final authProvider = Provider.of<AuthProvider>(context!);
    Provider.of<SideMenuProvider>(context, listen: false).setCurrentPageUrl(Flurorouter.typeUsersRoute);

    if (authProvider.authStatus == AuthStatus.authenticated) {
      return const TypeUsersView();
    } else {
      return const HomeScreen();
    }
  });
}
