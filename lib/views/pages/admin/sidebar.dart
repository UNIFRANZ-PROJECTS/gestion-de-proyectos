import 'package:flutter/material.dart';
import 'package:gestion_projects/views/pages/admin/widgets/logo.dart';
import 'package:gestion_projects/views/pages/admin/widgets/menu_item.dart';
import 'package:gestion_projects/views/pages/admin/widgets/text_separator.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/router/router.dart';
import 'package:gestion_projects/services/navigation_service.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void navigateTo(String routeName) {
    NavigationService.replaceTo(routeName);
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    final sideMenuProvider = Provider.of<SideMenuProvider>(context);

    return Container(
      color: const Color(0xff151E28),
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
                  onPressed: () => navigateTo(Flurorouter.dashboardRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
                ),
                const TextSeparator(text: 'Administración de gestiones'),
                MenuItem(
                  text: 'Gestiones',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.seasonsRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.seasonsRoute,
                ),
                MenuItem(
                  text: 'Etapas',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.stagesRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.stagesRoute,
                ),
                MenuItem(
                  text: 'Requisitos',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.requirementsRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.requirementsRoute,
                ),
                const TextSeparator(text: 'Administración de proyectos'),
                MenuItem(
                  text: 'Proyectos',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.projectRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.projectRoute,
                ),
                MenuItem(
                  text: 'Categorias',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.categoriesRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.categoriesRoute,
                ),
                MenuItem(
                  text: 'Tipos de proyectos',
                  icon: Icons.event_available_sharp,
                  onPressed: () => navigateTo(Flurorouter.typeProjectsRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.typeProjectsRoute,
                ),
                const TextSeparator(text: 'Administración de usuarios'),
                MenuItem(
                  text: 'Usuarios',
                  icon: Icons.people_alt_outlined,
                  onPressed: () => navigateTo(Flurorouter.usersRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
                ),
                MenuItem(
                  text: 'Tipos de usuario',
                  icon: Icons.people_alt_outlined,
                  onPressed: () => navigateTo(Flurorouter.typeUsersRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.typeUsersRoute,
                ),
                MenuItem(
                  text: 'Roles',
                  icon: Icons.people_alt_outlined,
                  onPressed: () => navigateTo(Flurorouter.rolesRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.rolesRoute,
                ),
                MenuItem(
                  text: 'Permisos',
                  icon: Icons.check_box,
                  onPressed: () => navigateTo(Flurorouter.permisionsRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.permisionsRoute,
                ),
                const TextSeparator(text: 'Ajustes'),
                MenuItem(
                  text: 'Docentes',
                  icon: Icons.co_present_rounded,
                  onPressed: () => navigateTo(Flurorouter.teacherRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.teacherRoute,
                ),
                MenuItem(
                  text: 'Materias',
                  icon: Icons.check_box,
                  onPressed: () => navigateTo(Flurorouter.subjectRoute),
                  isActive: sideMenuProvider.currentPage == Flurorouter.subjectRoute,
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
