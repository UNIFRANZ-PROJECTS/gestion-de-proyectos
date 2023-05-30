import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestion_projects/router/app_routes.dart';
import 'package:gestion_projects/services/auth_service.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/provider/app_state.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/provider/sidemenu_provider.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:gestion_projects/utils/style.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'bloc/blocs.dart';

void main() async {
  await LocalStorage.configurePrefs();

  WidgetsFlutterBinding.ensureInitialized();
  CafeApi.configureDio();
  Get.lazyPut(() => AuthService());
  // QR.setUrlStrategy();
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RequirementBloc()),
          BlocProvider(create: (_) => SeasonBloc()),
          BlocProvider(create: (_) => StageBloc()),
          BlocProvider(create: (_) => TypeProjectBloc()),
          BlocProvider(create: (_) => CategoryBloc()),
          BlocProvider(create: (_) => ProjectBloc()),
          BlocProvider(create: (_) => SubjectBloc()),
          BlocProvider(create: (_) => TeacherBloc()),
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => PermisionBloc()),
          BlocProvider(create: (_) => RolBloc()),
          BlocProvider(create: (_) => TypeUserBloc()),
          BlocProvider(create: (_) => ParallelBloc()),
          BlocProvider(create: (_) => SuscribeBloc()),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider()),
            ChangeNotifierProvider(lazy: false, create: (_) => SideMenuProvider()),
            ChangeNotifierProvider(create: (_) => AppState()),
            ChangeNotifierProvider(create: (_) => AuthData()),
          ],
          child: const MyApp(),
        )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRoutes = AppRoutes();
    appRoutes.setup();
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Spanish
        Locale('en', 'US'), // English
      ],
      debugShowCheckedModeBanner: false,
      theme: styleLigth(),
      title: 'GESTION DE PROYECTOS',
      routeInformationParser: const QRouteInformationParser(),
      routerDelegate: QRouterDelegate(
        appRoutes.routes,
      ),
      restorationScopeId: 'app',
    );
  }
}
