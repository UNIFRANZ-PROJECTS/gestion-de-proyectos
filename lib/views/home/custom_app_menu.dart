import 'package:flutter/material.dart';
import 'package:gestion_projects/views/home/custom_flat_button.dart';
import 'package:qlevar_router/qlevar_router.dart';

// import '../../locator.dart';

class CustomAppMenu extends StatelessWidget {
  const CustomAppMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraints) => (constraints.maxWidth > 520) ? _TableDesktopMenu() : _MobileMenu());
  }
}

class _TableDesktopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Image(
                image: AssetImage(
                  'assets/images/logo.png',
                ),
                height: 150),
          ),
          const Spacer(),
          // CustomFlatButton(
          //   text: 'Acerca de Nosotros',
          //   backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFC233)),
          //   // onPressed: () => Navigator.pushNamed(context, '/stateful'),
          //   // onPressed: () => locator<NavigationService>().navigateTo('/stateful'),
          //   onPressed: () {},
          // ),
          // const SizedBox(width: 10),
          // CustomFlatButton(
          //   text: 'Cursos',
          //   backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFFFC233)),
          //   // onPressed: () => locator<NavigationService>().navigateTo('/provider'),
          //   onPressed: () {},
          // ),
          // const SizedBox(width: 10),
          CustomFlatButton(
            text: 'Iniciar Sesión',
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF333333)),
            onPressed: () => QR.navigator.replaceLast('/login'),
            colorText: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFlatButton(
            text: 'Contador Stateful',
            // onPressed: () => Navigator.pushNamed(context, '/stateful'),
            // onPressed: () => locator<NavigationService>().navigateTo('/stateful'),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          CustomFlatButton(
            text: 'Contador Provider',
            // onPressed: () => locator<NavigationService>().navigateTo('/provider'),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          CustomFlatButton(
            text: 'Otra página',
            // onPressed: () => locator<NavigationService>().navigateTo('/abc123'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
