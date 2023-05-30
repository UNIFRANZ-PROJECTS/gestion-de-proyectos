import 'package:flutter/material.dart';
import 'package:gestion_projects/components/widgets/notifications_indicator.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/services/local_storage.dart';

class Navbar extends StatefulWidget {
  final Function() infoUser;
  final String title;
  const Navbar({super.key, required this.infoUser, required this.title});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authData = authModelFromJson(LocalStorage.prefs.getString('userData')!);

    return SizedBox(
      width: double.infinity,
      // height: 50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            if (size.width <= 700)
              IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () => SideMenuProvider.openMenu()),
            const SizedBox(width: 5),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text('HOLA ${authData.name} ${authData.lastName}'),
            const NotificationsIndicator(),
          ],
        ),
      ),
    );
  }
}
