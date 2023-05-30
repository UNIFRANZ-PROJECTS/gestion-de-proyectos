import 'package:flutter/material.dart';

import 'package:gestion_projects/components/compoents.dart';

class View404 extends StatelessWidget {
  const View404({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('404', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('No se encontró la página', style: TextStyle(fontSize: 20)),
              ButtonComponent(text: 'Regresar', onPressed: () => Navigator.pushNamed(context, '/')),
            ],
          ),
        ),
      ),
    );
  }
}
