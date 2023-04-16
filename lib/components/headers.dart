import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:provider/provider.dart';

import 'package:gestion_projects/components/compoents.dart';

class HedersComponent extends StatefulWidget {
  final String? titleHeader;
  final String? title;
  final bool center;
  final bool? stateBell;
  final GlobalKey? keyNotification;
  final bool? stateIconMuserpol;
  final bool stateBack;
  final bool initPage;
  final Function()? onPressLogin;
  final Function()? onPressLogout;
  const HedersComponent({
    Key? key,
    this.titleHeader,
    this.title = '',
    this.center = false,
    this.stateBell = false,
    this.keyNotification,
    this.stateIconMuserpol = true,
    this.stateBack = true,
    this.initPage = true,
    this.onPressLogin,
    this.onPressLogout,
  }) : super(key: key);

  @override
  State<HedersComponent> createState() => _HedersComponentState();
}

class _HedersComponentState extends State<HedersComponent> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
            leadingWidth: 120,
            leading: widget.initPage
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/logo.png',
                    ))
                : null,
            actions: widget.initPage
                ? [
                    authProvider.authStatus != AuthStatus.authenticated
                        ? ButtonComponent(text: 'INGRESAR', onPressed: () => widget.onPressLogin!())
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${json.decode(LocalStorage.prefs.getString('student')!)['nombre']} ${json.decode(LocalStorage.prefs.getString('student')!)['apellido']}'),
                                    Text('${json.decode(LocalStorage.prefs.getString('student')!)['carrera']}'),
                                  ],
                                ),
                              ),
                              ButtonComponent(text: 'SALIR', onPressed: () => widget.onPressLogout!())
                            ],
                          ),
                  ]
                : null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(widget.title!,
              textAlign: widget.center ? TextAlign.center : TextAlign.start,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
