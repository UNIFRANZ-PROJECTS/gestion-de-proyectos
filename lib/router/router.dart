import 'package:fluro/fluro.dart';
import 'package:gestion_projects/router/dashboard_handlers.dart';
import 'package:gestion_projects/router/no_page_found_handlers.dart';

import 'admin_handlers.dart';

class Flurorouter {
  static final FluroRouter router = FluroRouter();

  static String rootRoute = '/';
  static String campusHomeRoute = '/:uid';

  // Auth Router
  static String loginRoute = '/admin/login';

  //Dashboard
  static String dashboardRoute = '/dashboard';
  //Teacher
  static String teacherRoute = '/dashboard/teacher';
  //Subject
  static String subjectRoute = '/dashboard/subject';
  //Project
  static String projectRoute = '/dashboard/project';
  //users
  static String usersRoute = '/dashboard/users';
  //permisos
  static String permisionsRoute = '/dashboard/permisions';
  //roles
  static String rolesRoute = '/dashboard/roles';
  //tipos de usuarios
  static String typeUsersRoute = '/dashboard/typeusers';

  static void configureRoutes() {
    router.define(rootRoute, handler: Home.home, transitionType: TransitionType.none);
    // Dashboard
    router.define(dashboardRoute, handler: DashboardHandlers.dashboard, transitionType: TransitionType.fadeIn);
    // Teacher
    router.define(teacherRoute, handler: DashboardHandlers.teacher, transitionType: TransitionType.fadeIn);
    // Subject
    router.define(subjectRoute, handler: DashboardHandlers.subject, transitionType: TransitionType.fadeIn);
    // Project
    router.define(projectRoute, handler: DashboardHandlers.project, transitionType: TransitionType.fadeIn);
    // Usuarios
    router.define(usersRoute, handler: DashboardHandlers.users, transitionType: TransitionType.fadeIn);
    // Permisos
    router.define(permisionsRoute, handler: DashboardHandlers.permisions, transitionType: TransitionType.fadeIn);
    // Roles
    router.define(rolesRoute, handler: DashboardHandlers.roles, transitionType: TransitionType.fadeIn);
    // Tipos de usuarios
    router.define(typeUsersRoute, handler: DashboardHandlers.typeUsers, transitionType: TransitionType.fadeIn);
    // 404 - Not Page Found
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
