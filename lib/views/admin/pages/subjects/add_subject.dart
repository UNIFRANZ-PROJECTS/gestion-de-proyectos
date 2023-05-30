import 'dart:convert';

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
  final SubjectModel? item;
  const AddTeacherForm({super.key, this.item, required this.titleheader});

  @override
  State<AddTeacherForm> createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController codeCtrl = TextEditingController();
  TextEditingController semesterCtrl = TextEditingController();
  bool stateLoading = false;
  @override
  void initState() {
    callAllTeachers();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        codeCtrl = TextEditingController(text: widget.item!.code);
        semesterCtrl = TextEditingController(text: '${widget.item!.semester}');
      });
    }
    super.initState();
  }

  callAllTeachers() async {
    debugPrint('obteniendo todos los docentes');
    CafeApi.configureDio();
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    return CafeApi.httpGet(teachers(null)).then((res) async {
      final teachers = listTeacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateListTeacher(teachers));
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
                child: Column(children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: titleName())
                  : Column(mainAxisSize: MainAxisSize.min, children: titleName()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Materia', onPressed: () => createSubject())
                      : ButtonComponent(text: 'Actualizar Materia', onPressed: () => updateSubject())
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
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: nameCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ÁÉÍÓÚáéíóúñÑ]")),
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
        controllerText: codeCtrl,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ÁÉÍÓÚáéíóúñÑ()-]")),
          LengthLimitingTextInputFormatter(100)
        ],
        onEditingComplete: () {},
        validator: (value) {
          if (value.isNotEmpty) {
            return null;
          } else {
            return 'Código';
          }
        },
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        labelText: "Código:",
        hintText: "Código",
      ),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: semesterCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")), LengthLimitingTextInputFormatter(2)],
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
          labelText: "Semestre:",
          hintText: "Semestre")
    ];
  }

  createSubject() async {
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'semester': semesterCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(subjects(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final user = subjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(AddItemSubject(user));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateSubject() {
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'code': codeCtrl.text.trim(),
      'semester': semesterCtrl.text.trim(),
    };
    return CafeApi.put(subjects(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final categoryEdit = subjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateItemSubject(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
