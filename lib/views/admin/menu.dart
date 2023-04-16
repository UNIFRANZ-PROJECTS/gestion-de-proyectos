import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_projects/components/compoents.dart';

import 'package:gestion_projects/services/local_storage.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final userData = json.decode(LocalStorage.prefs.getString('userData')!);
    return Drawer(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.network(
                                'https://dl.airtable.com/DH4ROlhgSVG6TpXY0xrI_large_Joel-Monegro-pic-458x458.jpg'),
                          ),
                        )),
                    Text(
                      'Hola ${userData['name']}!',
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Stack(children: [
              // const Formtop(),
              // const FormButtom(),
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Mis datos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ItemList(
                        icon: Icons.badge_sharp,
                        text: 'Rol: ${userData['rol']}',
                      ),
                      ItemList(
                        icon: Icons.badge_sharp,
                        text: 'Tipo de usuario: ${userData['type_user']}',
                      ),
                      const Text(
                        'Carreras:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                            border: TableBorder.all(color: Colors.black),
                            columnWidths: const {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(7),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              for (final item in userData['careerIds'])
                                tableInfo('${item['abbreviation']}', '${item['campus']}'),
                            ]),
                      ),
                      const Divider(height: 0.03),
                      const Text(
                        'Configuración general',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ItemList(
                        icon: Icons.lock,
                        text: 'Cambiar contraseña',
                        stateLoading: stateLoading,
                        onPressed: () {},
                      ),
                    ],
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
