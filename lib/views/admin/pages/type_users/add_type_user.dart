import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/type_user.model.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddTypeUserForm extends StatefulWidget {
  final TypeUserModel? item;
  const AddTypeUserForm({super.key, this.item});

  @override
  State<AddTypeUserForm> createState() => _AddTypeUserFormState();
}

class _AddTypeUserFormState extends State<AddTypeUserForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  bool stateLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HedersComponent(
                title: 'Nuevo Tipo de usuario',
                initPage: false,
              ),
              InputComponent(
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
              !stateLoading
                  ? ButtonComponent(
                      text: 'Crear Tipo de usuario', onPressed: () => widget.item == null ? createRol() : editRol())
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

  createRol() async {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(typeUsers(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(json.encode(res.data['tipoUsuario']));
      typeUserBloc.add(AddItemTypeUser(typeUserItemModelFromJson(json.encode(res.data['tipoUsuario']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  editRol() async {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(typeUsers(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final typeUser = typeUserItemModelFromJson(json.encode(res.data['tipoUsuario']));
      typeUserBloc.add(UpdateItemTypeUser(typeUser));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
