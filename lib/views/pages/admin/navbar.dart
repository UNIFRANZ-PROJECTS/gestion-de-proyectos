import 'package:flutter/material.dart';
import 'package:gestion_projects/views/pages/admin/widgets/navbar_avatar.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';

class Navbar extends StatefulWidget {
  final Function() infoUser;
  const Navbar({super.key, required this.infoUser});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  TextEditingController searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: buildBoxDecoration(),
      child: Row(
        children: [
          if (size.width <= 700)
            IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () => SideMenuProvider.openMenu()),

          const SizedBox(width: 5),

          // Search input
          // if (size.width > 390)
          //   ConstrainedBox(
          //       constraints: const BoxConstraints(maxWidth: 250),
          //       child: InputComponent(
          //         textInputAction: TextInputAction.done,
          //         controllerText: searchCtrl,
          //         inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
          //         onEditingComplete: () {},
          //         keyboardType: TextInputType.text,
          //         textCapitalization: TextCapitalization.characters,
          //         icon: Icons.search,
          //         labelText: "Buscar",
          //       )),

          const Spacer(),

          // const NotificationsIndicator(),
          const SizedBox(width: 10),
          IconButton(icon: const NavbarAvatar(), onPressed: () => widget.infoUser()),
          const SizedBox(width: 10)
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() =>
      const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]);
}
