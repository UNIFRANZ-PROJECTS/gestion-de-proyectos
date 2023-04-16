import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/models/role.model.dart';
import 'package:gestion_projects/models/type_user.model.dart';

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
  List<String> carrerIds = [];
  bool stateLoading = false;
  String? idRolSelect; //✅
  String? idTypeUserSelect; //✅

  @override
  void initState() {
    super.initState();

    callAllRoles();
    callAllTypeUsers();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        emailCtrl = TextEditingController(text: widget.item!.email);
        idRolSelect = widget.item!.rol.id;
        idTypeUserSelect = widget.item!.typeUser.id;
        // carrerIds = [...widget.item!.careerIds.map((e) => e.id!).toList()];
      });
    }
  }

  callAllRoles() async {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    debugPrint('obteniendo todos los roles');
    CafeApi.configureDio();
    return CafeApi.httpGet(roles(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['roles'])}');
      rolBloc.add(UpdateListRol(rolesModelFromJson(json.encode(res.data['roles']))));
    });
  }

  callAllTypeUsers() async {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    debugPrint('obteniendo todos los tipos de usuarios');
    CafeApi.configureDio();
    return CafeApi.httpGet(typeUsers(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['tiposUsuarios'])}');
      typeUserBloc.add(UpdateListTypeUser(typeUserModelFromJson(json.encode(res.data['tiposUsuarios']))));
    });
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
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: nameCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
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
      ),
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: lastNameCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
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
      ),
    ];
  }

  List<Widget> titleDescription() {
    return [
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: emailCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
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
      ),
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: codeCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
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
      ),
    ];
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
          defect: widget.item == null ? null : widget.item!.rol.name,
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
          defect: widget.item == null ? null : widget.item!.typeUser.name,
          values: (idSelect) => setState(() => idTypeUserSelect = idSelect),
          // error: errorCategory,
          textError: 'Seleccióna una categoría',
        ),
      ),
    ];
  }

  createUser() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
      'careerIds': carrerIds,
    });
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(users(null), formData).then((res) async {
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
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'typeUser': idTypeUserSelect,
      'rol': idRolSelect,
      'careerIds': carrerIds,
    });
    return CafeApi.put(users(widget.item!.id), formData).then((res) async {
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
