import 'package:gestion_projects/router/auth_middleware.dart';
import 'package:gestion_projects/router/deferred_loader.dart';
import 'package:gestion_projects/views/dashboard_layout.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'package:gestion_projects/views/admin/pages/dashboard/dashboard_view.dart' deferred as table;
import 'package:gestion_projects/views/admin/pages/seasons/seasons_view.dart' deferred as seasons;
import 'package:gestion_projects/views/admin/pages/stages/stages_view.dart' deferred as stages;
import 'package:gestion_projects/views/admin/pages/requirements/requirements_view.dart' deferred as requirements;
import 'package:gestion_projects/views/admin/pages/projects/projects_view.dart' deferred as project;
import 'package:gestion_projects/views/admin/pages/categories/categories_view.dart' deferred as category;
import 'package:gestion_projects/views/admin/pages/type_projects/type_projects_view.dart' deferred as type_project;
import 'package:gestion_projects/views/admin/pages/users/users_view.dart' deferred as user;
import 'package:gestion_projects/views/admin/pages/type_users/type_users_view.dart' deferred as type_user;
import 'package:gestion_projects/views/admin/pages/roles/roles_view.dart' deferred as role;
import 'package:gestion_projects/views/admin/pages/permisions/permisions_view.dart' deferred as permision;
import 'package:gestion_projects/views/admin/pages/teachers/teachers_view.dart' deferred as teacher;
import 'package:gestion_projects/views/admin/pages/subjects/subjects_view.dart' deferred as subject;
import 'package:gestion_projects/views/admin/pages/parallels/parallels_view.dart' deferred as parallel;
import 'package:gestion_projects/views/admin/pages/suscribes/suscribes_view.dart' deferred as suscribe;

class DashboardRoutes {
  //dasboards
  static String dashboardRoute = 'dashboard';
  static String tableRoute = 'table';
  //seasons
  static const String seasonsRoute = 'seasons';
  //stages
  static const String stagesRoute = 'stages';
  //requirements
  static const String requirementsRoute = 'requirements';
  //suscribe
  static const String suscribeRoute = 'suscribe';
  //projects
  static const String projectRoute = 'project';
  //categories
  static const String categoriesRoute = 'categories';
  //tipeProjects
  static const String typeProjectsRoute = 'typeprojects';
  //users
  static const String usersRoute = 'users';
  //typeUsers
  static const String typeUsersRoute = 'typeusers';
  //roles
  static const String rolesRoute = 'roles';
  //permisions
  static const String permisionsRoute = 'permisions';
  //teachers
  static const String teacherRoute = 'teacher';
  //subjects
  static const String subjectRoute = 'subject';
  //parallels
  static const String parallelsRoute = 'parallels';
  final route = QRoute.withChild(
    path: '/$dashboardRoute',
    name: dashboardRoute,
    initRoute: '/$tableRoute',
    meta: {
      'title': 'Dashboard',
    },
    middleware: [
      // Set the auth middleware to allow only to the logged in users
      // to access the dashboard, the children routes will be protected
      // by this middleware too
      AuthMiddleware(),
    ],
    builderChild: (router) => DashboardLayout(router: router),
    children: [
      //dashboard
      QRoute(
        path: '/$tableRoute',
        name: tableRoute,
        builder: () => table.DashboardView(),
        middleware: [
          DefferedLoader(table.loadLibrary),
        ],
      ),
      //season
      QRoute(
        path: '/$seasonsRoute',
        name: seasonsRoute,
        builder: () => seasons.SeasonsView(),
        middleware: [
          DefferedLoader(seasons.loadLibrary),
        ],
      ),
      //stage
      QRoute(
        path: '/$stagesRoute',
        builder: () => stages.StagesView(),
        middleware: [
          DefferedLoader(stages.loadLibrary),
        ],
      ),
      //requirement
      QRoute(
        path: '/$requirementsRoute',
        builder: () => requirements.RequirementsView(),
        middleware: [
          DefferedLoader(requirements.loadLibrary),
        ],
      ),
      //suscribe
      QRoute(
        path: '/$suscribeRoute',
        builder: () => suscribe.SuscribesView(),
        middleware: [
          DefferedLoader(suscribe.loadLibrary),
        ],
      ),
      //proyect
      QRoute(
        path: '/$projectRoute',
        builder: () => project.ProjectView(),
        middleware: [
          DefferedLoader(project.loadLibrary),
        ],
      ),
      //category
      QRoute(
        path: '/$categoriesRoute',
        builder: () => category.CategoriesView(),
        middleware: [
          DefferedLoader(category.loadLibrary),
        ],
      ),
      //typeProject
      QRoute(
        path: '/$typeProjectsRoute',
        builder: () => type_project.TypeProjectsView(),
        middleware: [
          DefferedLoader(type_project.loadLibrary),
        ],
      ),
      //user
      QRoute(
        path: '/$usersRoute',
        builder: () => user.UsersView(),
        middleware: [
          DefferedLoader(user.loadLibrary),
        ],
      ),
      //typeUser
      QRoute(
        path: '/$typeUsersRoute',
        builder: () => type_user.TypeUsersView(),
        middleware: [
          DefferedLoader(type_user.loadLibrary),
        ],
      ),
      //role
      QRoute(
        path: '/$rolesRoute',
        builder: () => role.RolesView(),
        middleware: [
          DefferedLoader(role.loadLibrary),
        ],
      ),
      //permision
      QRoute(
        path: '/$permisionsRoute',
        builder: () => permision.PermisionsView(),
        middleware: [
          DefferedLoader(permision.loadLibrary),
        ],
      ),
      //teacher
      QRoute(
        path: '/$teacherRoute',
        builder: () => teacher.TeacherView(),
        middleware: [
          DefferedLoader(teacher.loadLibrary),
        ],
      ),
      //subject
      QRoute(
        path: '/$subjectRoute',
        builder: () => subject.SubjectView(),
        middleware: [
          DefferedLoader(subject.loadLibrary),
        ],
      ),
      //parallel
      QRoute(
        path: '/$parallelsRoute',
        builder: () => parallel.ParallelsView(),
        middleware: [
          DefferedLoader(parallel.loadLibrary),
        ],
      ),
    ],
  );
}
