import 'package:fluro/fluro.dart';
import 'package:gestion_projects/views/home/home.dart';

class Home {
  //home
  static Handler home = Handler(handlerFunc: (context, params) {
    return const HomeScreen();
  });
}
