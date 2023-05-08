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
  //categorias
  static String categoriesRoute = '/dashboard/categories';
  //tipos de proyectos
  static String typeProjectsRoute = '/dashboard/typeprojects';
  //temporadas
  static String seasonsRoute = '/dashboard/seasons';
  //etapas
  static String stagesRoute = '/dashboard/stages';
  //requermientos
  static String requirementsRoute = '/dashboard/requirements';

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
    // Categorias
    router.define(categoriesRoute, handler: DashboardHandlers.categories, transitionType: TransitionType.fadeIn);
    // Tipos de proyectos
    router.define(typeProjectsRoute, handler: DashboardHandlers.typeProjects, transitionType: TransitionType.fadeIn);
    // Temporadas
    router.define(seasonsRoute, handler: DashboardHandlers.seasons, transitionType: TransitionType.fadeIn);
    // Etapas
    router.define(stagesRoute, handler: DashboardHandlers.stages, transitionType: TransitionType.fadeIn);
    // Requermientos
    router.define(requirementsRoute, handler: DashboardHandlers.requirements, transitionType: TransitionType.fadeIn);
    // 404 - Not Page Found
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
