import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';

import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddUserForm extends StatefulWidget {
  final UserModel? item;
  const AddUserForm({super.key, this.item});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  bool stateLoading = false;
  String? idRolSelect; //✅
  String? idTypeUserSelect; //✅
  String textRol = '';
  String textTypeUser = '';

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        emailCtrl = TextEditingController(text: widget.item!.email);
        idRolSelect = widget.item!.rol.id;
        idTypeUserSelect = widget.item!.typeUser.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HedersComponent(
                title: 'Nuevo Usuario',
                initPage: false,
              ),
              (size.width > 1000)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [...titleName()],
                        ),
                        Row(
                          children: [...titleDescription()],
                        ),
                        Row(
                          children: [...listSelect()],
                        ),
                      ],
                    )
                  : Column(
                      children: [...titleName(), ...titleDescription(), ...listSelect()],
                    ),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Usuario', onPressed: () => createUser())
                      : ButtonComponent(text: 'Actualizar Usuario', onPressed: () => updateUser())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> titleName() {
    return [
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: nameCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-ZÁÉÍÓÚáéíóúÑñ ]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Nombre';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Nombre:",
          hintText: "Nombre"),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: lastNameCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-ZÁÉÍÓÚáéíóúÑñ ]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Apellido';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Apellido:",
          hintText: "Apellido"),
    ];
  }

  List<Widget> titleDescription() {
    return [
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: emailCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-ZñÑ@.]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Correo';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Correo:",
          hintText: "Correo"),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: codeCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9A-Z ]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Codigo';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Codigo:",
          hintText: "Codigo"),
    ];
  }

  List<Widget> listSelect() {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: true).state.listRoles.where((e) => e.state).toList();
    final typeUserBloc =
        BlocProvider.of<TypeUserBloc>(context, listen: true).state.listTypeUser.where((e) => e.state).toList();
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

  createUser() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(users(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final user = userModelFromJson(json.encode(res.data['usuario']));
      userBloc.add(AddItemUser(user));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateUser() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
    };
    return CafeApi.put(users(widget.item!.id), body).then((res) async {
      final user = userModelFromJson(json.encode(res.data['usuario']));
      userBloc.add(UpdateItemUser(user));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
