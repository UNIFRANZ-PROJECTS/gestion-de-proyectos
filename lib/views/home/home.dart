import 'package:flutter/material.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/provider/auth_provider.dart';

import 'package:gestion_projects/provider/app_state.dart';
import 'package:gestion_projects/services/navigation_service.dart';
import 'package:gestion_projects/views/home/login_client.dart';
import 'package:provider/provider.dart';

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
    final selectedCategoryId = Provider.of<AppState>(context).selectedCategoryId;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Column(
          children: [
            HedersComponent(
              onPressLogin: () => loginshow(context),
              onPressLogout: () => {},
            ),
            // Text('${searchState}'),

            // Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //     child: Text('Hoy es ${DateFormat('dd, MMMM yyyy ', "es_ES").format(DateTime.now())}')),
            // Expanded(
            //   child: BlocBuilder<EventBloc, EventState>(
            //     builder: (context, state) {
            //       final events = _getEvents(state, selectedCategoryId);
            //       return (size.width > 1000)
            //           ? GridView.count(
            //               childAspectRatio: 1,
            //               crossAxisCount: 4,
            //               children: events.map(itemEvent).toList(),
            //             )
            //           : SingleChildScrollView(
            //               child: Column(
            //                 children: events.map(itemEvent).toList(),
            //               ),
            //             );
            //     },
            //   ),
            // ),
          ],
        ));
  }

  Future<bool> _onBackPressed() async {
    NavigationService.replaceTo('/');
    return false;
  }

  void loginshow(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => const DialogLogin());
  }
}
