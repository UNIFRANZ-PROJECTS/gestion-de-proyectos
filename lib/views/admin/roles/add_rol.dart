import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/permision.model.dart';
import 'package:gestion_projects/models/role.model.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddRolForm extends StatefulWidget {
  final RolesModel? item;
  const AddRolForm({super.key, this.item});

  @override
  State<AddRolForm> createState() => _AddRolFormState();
}

class _AddRolFormState extends State<AddRolForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  List<String> permisionIds = [];
  bool stateLoading = false;

  @override
  void initState() {
    super.initState();
    callAllPermisions();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        permisionIds = [...widget.item!.permisionIds.map((e) => e.id).toList()];
      });
    }
  }

  callAllPermisions() async {
    final permisionBloc = BlocProvider.of<PermisionBloc>(context, listen: false);
    debugPrint('obteniendo todos los permisos');
    CafeApi.configureDio();
    return CafeApi.httpGet(permisions()).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['permisos'])}');
      permisionBloc.add(UpdateListPermision(permisionsModelFromJson(json.encode(res.data['permisos']))));
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
                title: 'Nuevo Rol',
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(
                      children: [...titleDescription()],
                    )
                  : Column(
                      children: [
                        ...titleDescription(),
                      ],
                    ),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Rol', onPressed: () => createRol())
                      : ButtonComponent(text: 'Actualizar Rol', onPressed: () => updateRol())
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

  List<Widget> titleDescription() {
    final permisionBloc = BlocProvider.of<PermisionBloc>(context, listen: true).state;

    final permisions = permisionBloc.listPermision.map((e) => MultiSelectItem<PermisionsModel>(e, e.name)).toList();
    List<PermisionsModel> filteredList = [];
    if (widget.item != null) {
      filteredList =
          permisionBloc.listPermision.where((e) => widget.item!.permisionIds.any((i) => i.id == e.id)).toList();
    }
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
          child: SelectMultiple(
        initialValue: widget.item != null ? filteredList : const [],
        items: permisions,
        labelText: 'Permiso(s):',
        hintText: 'Permiso(s)',
        onChanged: (values) =>
            setState(() => permisionIds = values.map((e) => permisionItemModelFromJson(json.encode(e)).id).toList()),
      )),
    ];
  }

  createRol() async {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'permisionIds': permisionIds,
    });
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(roles(null), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(json.encode(res.data['rol']));
      rolBloc.add(AddItemRol(rolItemModelFromJson(json.encode(res.data['rol']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateRol() {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    CafeApi.configureDio();

    if (!formKey.currentState!.validate()) return;
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'permisionIds': permisionIds,
    });
    debugPrint('formData ${formData.fields}');
    return CafeApi.put(roles(widget.item!.id), formData).then((res) async {
      debugPrint(json.encode(res.data['rol']));
      rolBloc.add(UpdateItemRol(rolItemModelFromJson(json.encode(res.data['rol']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
