import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddTeacherForm extends StatefulWidget {
  final String titleheader;
  final TeacherModel? item;
  const AddTeacherForm({super.key, this.item, required this.titleheader});

  @override
  State<AddTeacherForm> createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController specialtyCtrl = TextEditingController();
  String? imageFile;
  Uint8List? bytes;
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
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: titleName())
                  : Column(mainAxisSize: MainAxisSize.min, children: titleName()),
              (size.width > 1000)
                  ? Row(children: details())
                  : Column(mainAxisSize: MainAxisSize.min, children: details()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Categoria', onPressed: () => createCategory())
                      : ButtonComponent(text: 'Actualizar Categoria', onPressed: () => updateCategory())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ]))));
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

  List<Widget> details() {
    return [
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: descriptionCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
              LengthLimitingTextInputFormatter(100)
            ],
            onEditingComplete: () {},
            validator: (value) {
              if (value.isNotEmpty) {
                return null;
              } else {
                return 'Descripción';
              }
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            labelText: "Descripción:",
            hintText: "Descripción"),
      ),
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: specialtyCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
              LengthLimitingTextInputFormatter(100)
            ],
            onEditingComplete: () {},
            validator: (value) {
              if (value.isNotEmpty) {
                return null;
              } else {
                return 'Especialidad';
              }
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            labelText: "Especialidad:",
            hintText: "Especialidad"),
      ),
    ];
  }

  createCategory() async {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'specialty': specialtyCtrl.text.trim(),
    });
    return CafeApi.post(teachers(null), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final teacher = teacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(AddItemTeacher(teacher));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'lastName': lastNameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'specialty': specialtyCtrl.text.trim(),
    });
    return CafeApi.put(teachers(widget.item!.id), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final categoryEdit = teacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateItemTeacher(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
