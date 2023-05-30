import 'package:flutter/material.dart';
import 'package:gestion_projects/components/widgets/logo.dart';
import 'package:gestion_projects/components/widgets/menu_item.dart';
import 'package:gestion_projects/components/widgets/text_separator.dart';
import 'package:gestion_projects/models/auth.model.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/router/dashboard_routes.dart';
// import 'package:gestion_projects/router/routes.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:provider/provider.dart';
import 'package:qlevar_router/qlevar_router.dart';

class Sidebar extends StatelessWidget {
  // final QRouter router;
  const Sidebar({super.key});

  void navigateTo(String routeName) {
    QR.to('${DashboardRoutes.dashboardRoute}/$routeName');
    // NavigationService.replaceTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    QR.log('Get Dashboard meta: ${QR.currentRoute.meta}');
    // final authData = Provider.of<AuthData>(context).authData;
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
    final authData = authModelFromJson(LocalStorage.prefs.getString('userData')!).rol;
    return SizedBox(
      width: 200,
      height: double.infinity,
      child: Column(
        children: [
          const Logo(),
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                const TextSeparator(text: 'Principal'),
                MenuItem(
                  text: 'Dashboard',
                  icon: Icons.compass_calibration_outlined,
                  onPressed: () => navigateTo(DashboardRoutes.tableRoute),
                  isActive: sideMenuProvider.currentPage == DashboardRoutes.tableRoute,
                ),
                if (authData.permisionIds
                    .where((e) => e.category == 'Requisitos' || e.category == 'Etapas' || e.category == 'Requisitos')
                    .isNotEmpty)
                  const TextSeparator(text: 'Administración de gestiones'),
                if (authData.permisionIds.where((e) => e.category == 'Temporadas').isNotEmpty)
                  MenuItem(
                    text: 'Temporada',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.seasonsRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.seasonsRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Etapas').isNotEmpty)
                  MenuItem(
                    text: 'Etapas',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.stagesRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.stagesRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Requisitos').isNotEmpty)
                  MenuItem(
                    text: 'Requisitos',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.requirementsRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.requirementsRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Requisitos').isNotEmpty)
                  MenuItem(
                    text: 'Inscripciones',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.suscribeRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.suscribeRoute,
                  ),
                if (authData.permisionIds
                    .where((e) =>
                        e.category == 'Proyectos' || e.category == 'Categorías' || e.category == 'Tipo Proyectos')
                    .isNotEmpty)
                  const TextSeparator(text: 'Administración de proyectos'),
                if (authData.permisionIds.where((e) => e.category == 'Proyectos').isNotEmpty)
                  MenuItem(
                    text: 'Proyectos',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.projectRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.projectRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Categorías').isNotEmpty)
                  MenuItem(
                    text: 'Categorias',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.categoriesRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.categoriesRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Tipo Proyectos').isNotEmpty)
                  MenuItem(
                    text: 'Tipos de proyectos',
                    icon: Icons.event_available_sharp,
                    onPressed: () => navigateTo(DashboardRoutes.typeProjectsRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.typeProjectsRoute,
                  ),
                if (authData.permisionIds
                    .where((e) =>
                        e.category == 'Usuarios' ||
                        e.category == 'Tipo Usuarios' ||
                        e.category == 'Roles' ||
                        e.category == 'Permisos')
                    .isNotEmpty)
                  const TextSeparator(text: 'Administración de usuarios'),
                if (authData.permisionIds.where((e) => e.category == 'Usuarios').isNotEmpty)
                  MenuItem(
                    text: 'Usuarios',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(DashboardRoutes.usersRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.usersRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Tipo Usuarios').isNotEmpty)
                  MenuItem(
                    text: 'Tipos de usuario',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(DashboardRoutes.typeUsersRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.typeUsersRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Roles').isNotEmpty)
                  MenuItem(
                    text: 'Roles',
                    icon: Icons.people_alt_outlined,
                    onPressed: () => navigateTo(DashboardRoutes.rolesRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.rolesRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Permisos').isNotEmpty)
                  MenuItem(
                    text: 'Permisos',
                    icon: Icons.check_box,
                    onPressed: () => navigateTo(DashboardRoutes.permisionsRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.permisionsRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Docentes' || e.category == 'Materias').isNotEmpty)
                  const TextSeparator(text: 'Ajustes'),
                if (authData.permisionIds.where((e) => e.category == 'Docentes').isNotEmpty)
                  MenuItem(
                    text: 'Docentes',
                    icon: Icons.co_present_rounded,
                    onPressed: () => navigateTo(DashboardRoutes.teacherRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.teacherRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Materias').isNotEmpty)
                  MenuItem(
                    text: 'Materias',
                    icon: Icons.check_box,
                    onPressed: () => navigateTo(DashboardRoutes.subjectRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.subjectRoute,
                  ),
                if (authData.permisionIds.where((e) => e.category == 'Materias').isNotEmpty)
                  MenuItem(
                    text: 'Paralelos',
                    icon: Icons.check_box,
                    onPressed: () => navigateTo(DashboardRoutes.parallelsRoute),
                    isActive: sideMenuProvider.currentPage == DashboardRoutes.parallelsRoute,
                  ),
                const SizedBox(height: 30),
                const TextSeparator(text: 'Salir'),
                MenuItem(
                    text: 'Salir sesión',
                    icon: Icons.exit_to_app_outlined,
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false).logout();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
