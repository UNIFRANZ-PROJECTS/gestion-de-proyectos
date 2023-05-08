import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Uint8List? bytes;
  bool stateLoading = false;
  String? idRolSelect; //✅
  String? idTypeUserSelect; //✅
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
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: true).state;
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: true).state;
    return [
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'Rol:',
          options: rolBloc.listRoles.where((e) => e.state).toList(),
          defect: null,
          values: (idSelect) => setState(() => idRolSelect = idSelect),
          // error: errorCategory,
          textError: 'Seleccióna una categoría',
        ),
      ),
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'Tipos de usuarios:',
          options: typeUserBloc.listTypeUser.where((e) => e.state).toList(),
          defect: null,
          values: (idSelect) => setState(() => idTypeUserSelect = idSelect),
          // error: errorCategory,
          textError: 'Seleccióna una categoría',
        ),
      ),
    ];
  }

  submitData() async {
    CafeApi.configureDio();
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'archivo': MultipartFile.fromBytes(bytes!),
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
    });
    return CafeApi.post(studentsXlxs(), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
