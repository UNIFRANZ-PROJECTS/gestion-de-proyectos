import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/rol/rol_bloc.dart';
import 'package:gestion_projects/bloc/type_user/type_user_bloc.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddUsersData extends StatefulWidget {
  const AddUsersData({super.key});

  @override
  State<AddUsersData> createState() => _AddUsersDataState();
}

class _AddUsersDataState extends State<AddUsersData> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  String? bytes;
  bool stateLoading = false;
  String? idRolSelect; //✅
  String? idTypeUserSelect; //✅
  String textRol = '';
  String textTypeUser = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const HedersComponent(
            title: 'Subir excel',
            initPage: false,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: InputXls(
                        onPressed: (imageBytes) => setState(() => bytes = imageBytes),
                        state: bytes == null ? false : true,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: listSelect(),
                      ),
                    )
                  ],
                ),
                !stateLoading
                    ? ButtonComponent(text: 'Cargar datos', onPressed: () => submitData())
                    : Center(
                        child: Image.asset(
                        'assets/gifs/load.gif',
                        fit: BoxFit.cover,
                        height: 20,
                      ))
              ],
            ),
          ),
        ]));
  }

  List<Widget> listSelect() {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: true).state.listRoles;
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: true).state.listTypeUser;
    return [
      Select(
        title: 'Rol:',
        options: [...rolBloc.map((e) => e.name)],
        textError: 'Seleccióna un rol',
        select: (value) {
          final item = rolBloc.firstWhere((e) => e.name == value.name);
          setState(() {
            idRolSelect = item.id;
            textRol = item.name;
          });
        },
        titleSelect: textRol,
      ),
      Select(
        title: 'Tipos de usuarios:',
        options: [...typeUserBloc.map((e) => e.name)],
        textError: 'Seleccióna un tipo de usuario',
        select: (value) {
          final item = typeUserBloc.firstWhere((e) => e.name == value.name);
          setState(() {
            idTypeUserSelect = item.id;
            textTypeUser = item.name;
          });
        },
        titleSelect: textTypeUser,
      ),
    ];
  }

  submitData() async {
    CafeApi.configureDio();
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'archivo': bytes,
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
    };
    return CafeApi.post(studentsXlxs(), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
