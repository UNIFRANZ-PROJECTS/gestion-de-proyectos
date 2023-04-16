import 'package:gestion_projects/views/pages/view_404.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluro/fluro.dart';

class NoPageFoundHandlers {
  static Handler noPageFound = Handler(handlerFunc: (context, params) {
    Provider.of<SideMenuProvider>(context!, listen: false).setCurrentPageUrl('/404');

    return const View404();
  });
}
