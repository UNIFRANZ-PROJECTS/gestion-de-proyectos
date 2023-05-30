import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddParallelForm extends StatefulWidget {
  final String titleheader;
  final ParallelModel? item;
  const AddParallelForm({super.key, this.item, required this.titleheader});

  @override
  State<AddParallelForm> createState() => _AddParallelFormState();
}

class _AddParallelFormState extends State<AddParallelForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  String? idTeacherSelect; //✅
  String? idSubjectSelect; //✅
  String textTeacher = '';
  String textSubject = '';
  bool stateLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: '${widget.item!.name}');
        textTeacher = '${widget.item!.teacherId.name} ${widget.item!.teacherId.lastName}';
        textSubject = widget.item!.subjectId.name;
        idTeacherSelect = widget.item!.teacherId.id;
        idSubjectSelect = widget.item!.subjectId.id;
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: titleName())
                  : Column(mainAxisSize: MainAxisSize.min, children: titleName()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Paralelo', onPressed: () => createParallel())
                      : ButtonComponent(text: 'Actualizar Paralelo', onPressed: () => updateParallel())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ]))));
  }

  List<Widget> titleName() {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: true).state.listTeacher;
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: true).state.listSubject;
    return [
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
              return 'Paralelo';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Paralelo:",
          hintText: "Paralelo"),
      Select(
        title: 'Docente:',
        options: [...teacherBloc.map((e) => '${e.name} ${e.lastName}')],
        textError: 'Seleccióna un docente',
        select: (value) {
          final item = teacherBloc.firstWhere((e) => '${e.name} ${e.lastName}' == value.name);
          setState(() {
            idTeacherSelect = item.id;
            textTeacher = '${item.name} ${item.lastName}';
          });
        },
        titleSelect: textTeacher,
      ),
      Select(
        title: 'Materia:',
        options: [...subjectBloc.map((e) => e.name)],
        textError: 'Seleccióna una materia',
        select: (value) {
          final item = subjectBloc.firstWhere((e) => e.name == value.name);
          setState(() {
            idSubjectSelect = item.id;
            textSubject = item.name;
          });
        },
        titleSelect: textSubject,
      ),
    ];
  }

  createParallel() async {
    final parallelBloc = BlocProvider.of<ParallelBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'teacherId': idTeacherSelect,
      'subjectId': idSubjectSelect,
    };
    return CafeApi.post(parallels(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final paralelo = parallelModelFromJson(json.encode(res.data['paralelo']));
      parallelBloc.add(AddItemParallel(paralelo));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateParallel() {
    final parallelBloc = BlocProvider.of<ParallelBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'teacherId': idTeacherSelect,
      'subjectId': idSubjectSelect,
    };
    return CafeApi.put(parallels(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final paralelo = parallelModelFromJson(json.encode(res.data['paralelo']));
      parallelBloc.add(UpdateItemParallel(paralelo));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
