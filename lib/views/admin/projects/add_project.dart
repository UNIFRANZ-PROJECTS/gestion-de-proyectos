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
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddProjectForm extends StatefulWidget {
  final String titleheader;
  final ProjectModel? item;
  const AddProjectForm({super.key, this.item, required this.titleheader});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  List<String> studentIds = [];
  List<String> subjectIds = [];
  bool stateLoading = false;
  String? idCategory;
  String? idTypeProject;
  @override
  void initState() {
    callAllUsers();
    callAllSubjects();
    callAllCategories();
    callAllTypeProjects();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
      });
    }
    super.initState();
  }

  callAllUsers() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');
    CafeApi.configureDio();
    return CafeApi.httpGet(users(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['usuarios'])}');
      userBloc.add(UpdateListUser(listUserModelFromJson(json.encode(res.data['usuarios']))));
    });
  }

  callAllSubjects() async {
    debugPrint('obteniendo todos las materias');
    CafeApi.configureDio();
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    return CafeApi.httpGet(subjects(null)).then((res) async {
      final subjects = listSubjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateListSubject(subjects));
    });
  }

  callAllCategories() async {
    debugPrint('obteniendo todos las categorias');
    CafeApi.configureDio();
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    return CafeApi.httpGet(categories(null)).then((res) async {
      final subjects = listElementModelFromJson(json.encode(res.data['categories']));
      categoryBloc.add(UpdateListCategory(subjects));
    });
  }

  callAllTypeProjects() async {
    debugPrint('obteniendo todos los tipos de proyectos');
    CafeApi.configureDio();
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: false);
    return CafeApi.httpGet(typeProjects(null)).then((res) async {
      final elements = listElementModelFromJson(json.encode(res.data['tiposProyectos']));
      typeProjectBloc.add(UpdateListTypeProject(elements));
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
                      ? ButtonComponent(text: 'Crear Proyecto', onPressed: () => createCategory())
                      : ButtonComponent(text: 'Actualizar Proyecto', onPressed: () => updateCategory())
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
            controllerText: descriptionCtrl,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@.]")),
              LengthLimitingTextInputFormatter(100)
            ],
            onEditingComplete: () {},
            validator: (value) {
              if (value.isNotEmpty) {
                return null;
              } else {
                return 'Descripcion';
              }
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            labelText: "Descripcion:",
            hintText: "Descripcion"),
      ),
    ];
  }

  List<Widget> titleDescription() {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: true).state;
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: true).state;
    return [
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'tipo de proyecto:',
          options: typeProjectBloc.listTypeProject.where((e) => e.state).toList(),
          // defect: widget.item == null ? null : widget.item!.rol.name,
          values: (idSelect) => setState(() => idTypeProject = idSelect),
          // error: errorCategory,
          textError: 'Seleccióna el tipo de proyecto',
        ),
      ),
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'categoria:',
          options: categoryBloc.listCategory.where((e) => e.state).toList(),
          // defect: widget.item == null ? null : widget.item!.typeUser.name,
          values: (idSelect) => setState(() => idCategory = idSelect),
          // error: errorCategory,
          textError: 'Seleccióna una categoría',
        ),
      ),
    ];
  }

  List<Widget> listSelect() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: true).state;
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: true).state;

    final students =
        userBloc.listUser.map((e) => MultiSelectItem<UserModel>(e, '${e.name} ${e.lastName}-${e.code}')).toList();
    final subjects =
        subjectBloc.listSubject.map((e) => MultiSelectItem<SubjectModel>(e, '${e.name}-${e.code}')).toList();
    // List<UserModel> filteredList = [];
    // if (widget.item != null) {
    //   filteredList =
    //       userBloc.listUser.where((e) => widget.item!.id.any((i) => i.id == e.id)).toList();
    // }

    //
    return [
      Flexible(
          child: SelectMultiple(
        initialValue: const [],
        items: students,
        labelText: 'Estudiante(s):',
        hintText: 'Estudiante(s)',
        onChanged: (values) =>
            setState(() => studentIds = values.map((e) => userModelFromJson(json.encode(e)).id).toList()),
      )),
      Flexible(
          child: SelectMultiple(
        initialValue: const [],
        items: subjects,
        labelText: 'Materia(s):',
        hintText: 'Materia(s)',
        onChanged: (values) =>
            setState(() => subjectIds = values.map((e) => subjectModelFromJson(json.encode(e)).id).toList()),
      )),
    ];
  }

  createCategory() async {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'typeProyect': idTypeProject,
      'category': idCategory,
      'subjectIDs': subjectIds,
      'studentIds': studentIds,
    });
    return CafeApi.post(projects(null), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final category = projectModelFromJson(json.encode(res.data['project']));
      projectBloc.add(AddItemProject(category));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'name': nameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'typeProyect': idTypeProject,
      'category': idCategory,
      'subjectIDs': subjectIds,
      'studentIds': studentIds,
    });
    return CafeApi.put(projects(widget.item!.id), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final project = projectModelFromJson(json.encode(res.data['project']));
      projectBloc.add(UpdateItemProject(project));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
