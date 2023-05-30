import 'package:flutter/material.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/views/admin/navbar.dart';
import 'package:gestion_projects/views/admin/sidebar.dart';
import 'package:qlevar_router/qlevar_router.dart';

class DashboardLayout extends StatefulWidget {
  final QRouter router;
  const DashboardLayout({super.key, required this.router});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();

    SideMenuProvider.menuController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    QR.log('Get Dashboard meta: ${QR.currentRoute.meta}');
    final size = MediaQuery.of(context).size;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xff151E28),
        endDrawerEnableOpenDragGesture: false,
        body: Stack(
          children: [
            Row(
              children: [
                if (size.width >= 700) const Sidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffEBEDEE),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Navbar(
                              title: '',
                              infoUser: () {
                                scaffoldKey.currentState!.openEndDrawer();
                              },
                            ),
                            Expanded(child: widget.router),
                            // Expanded(child: widget.child)
                          ],
                        )),
                  ),
                ),
                // Contenedor de nuestro view
              ],
            ),
            // if (size.width < 700)
            //   AnimatedBuilder(
            //       animation: SideMenuProvider.menuController,
            //       builder: (context, _) => Stack(
            //             children: [
            //               if (SideMenuProvider.isOpen)
            //                 Opacity(
            //                   opacity: SideMenuProvider.opacity.value,
            //                   child: GestureDetector(
            //                     onTap: () => SideMenuProvider.closeMenu(),
            //                     child: Container(
            //                       width: size.width,
            //                       height: size.height,
            //                       color: Colors.black26,
            //                     ),
            //                   ),
            //                 ),
            //               Transform.translate(
            //                 offset: Offset(SideMenuProvider.movement.value, 0),
            //                 child: const Sidebar(),
            //               )
            //             ],
            //           ))
          ],
        ));
  }
}
