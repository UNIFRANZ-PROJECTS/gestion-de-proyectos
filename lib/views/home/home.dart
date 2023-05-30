import 'package:flutter/material.dart';
import 'package:gestion_projects/views/home/custom_app_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchState = false;
  TextEditingController searchCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: Column(
        children: [
          CustomAppMenu(),
          Expanded(
              child: (size.width > 1000)
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      text(),
                      logo(),
                    ])
                  : Column(
                      children: [
                        logo(),
                        text(),
                      ],
                    ))
        ],
      ),
    );
  }

  Widget text() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: (size.width > 1000) ? 1 : 3,
        child: Center(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 80 : 20),
                child: const Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'Bienvenido(a) Centro de estudianes',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]))));
  }

  Widget logo() {
    final size = MediaQuery.of(context).size;
    return Expanded(
        flex: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (size.width > 1000) ? 0 : 20),
          child: const Center(
            child: Image(
              image: AssetImage(
                'assets/images/fondo.png',
              ),
            ),
          ),
        ));
  }
}
