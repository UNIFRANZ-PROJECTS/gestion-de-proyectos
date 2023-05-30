import 'dart:convert';

import 'package:flutter/material.dart';
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
  List<String> studentIds = [];
  List<String> subjectIds = [];
  List<ParallelModel> parallelIDs = [];
  bool stateLoading = false;
  String? idCategory;
  String? idTypeProject;
  String textTypeProject = '';
  String textCategory = '';
  List<String> textTeachers = [];
  @override
  void initState() {
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.project.title);
        idCategory = widget.item!.project.category.id;
        textCategory = widget.item!.project.category.name;
        idTypeProject = widget.item!.project.typeProyect.id;
        textTypeProject = widget.item!.project.typeProyect.name;
        studentIds = [...widget.item!.project.studentIds.map((e) => e.id)];
        // parallelIDs = [...];
// ...widget.item!.materias.map((e) => e.parallelId)
      });
    }
    super.initState();
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
                  ? Row(children: titleDescription())
                  : Column(mainAxisSize: MainAxisSize.min, children: titleDescription()),
              (size.width > 1000)
                  ? Row(children: listSelect())
                  : Column(mainAxisSize: MainAxisSize.min, children: listSelect()),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: listTeachers(),
              ),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Proyecto', onPressed: () => createProject())
                      : ButtonComponent(text: 'Actualizar Proyecto', onPressed: () => uodateProject())
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
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Titulo';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Titulo:",
          hintText: "Titulo"),
    ];
  }

  List<Widget> titleDescription() {
    final categoryBloc =
        BlocProvider.of<CategoryBloc>(context, listen: true).state.listCategory.where((e) => e.state).toList();
    final typeProjectBloc =
        BlocProvider.of<TypeProjectBloc>(context, listen: true).state.listTypeProject.where((e) => e.state).toList();

    return [
      Select(
        title: 'tipo de proyecto:',
        options: [...typeProjectBloc.where((e) => e.state).toList().map((e) => e.name)],
        textError: 'Seleccióna el tipo de proyecto',
        select: (value) {
          final item = typeProjectBloc.firstWhere((e) => e.name == value.name);
          setState(() {
            idTypeProject = item.id;
            textTypeProject = item.name;
          });
        },
        titleSelect: textTypeProject,
      ),
      Select(
        title: 'categoria:',
        options: [...categoryBloc.where((e) => e.state).toList().map((e) => e.name)],
        textError: 'Seleccióna una categoría',
        select: (value) {
          final item = categoryBloc.firstWhere((e) => e.name == value.name);
          setState(() {
            idCategory = item.id;
            textCategory = item.name;
          });
        },
        titleSelect: textCategory,
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
    return [
      Expanded(
        child: SelectMultiple(
          initialValue: const [],
          items: students,
          labelText: 'Estudiante(s):',
          hintText: 'Estudiante(s)',
          onChanged: (values) =>
              setState(() => studentIds = values.map((e) => userModelFromJson(json.encode(e)).id).toList()),
        ),
      ),
      Expanded(
        child: SelectMultiple(
          initialValue: const [],
          items: subjects,
          labelText: 'Materia(s):',
          hintText: 'Materia(s)',
          onChanged: (values) => setState(() {
            subjectIds = values.map((e) => (e as SubjectModel).id).toList();
            parallelIDs = parallelIDs.where((e) => subjectIds.contains(e.subjectId.id)).toList();
          }),
        ),
      ),
    ];
  }

  List<Widget> listTeachers() {
    final listParallel = BlocProvider.of<ParallelBloc>(context, listen: true).state.listParallel;
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: true).state;
    final listSubject = subjectBloc.listSubject.where((e) => subjectIds.contains(e.id));

    return [
      for (final item in listSubject)
        Select(
          title: '${item.name}:',
          options: [
            ...listParallel
                .where((e) => e.subjectId.id == item.id)
                .toList()
                .map((e) => '${e.teacherId.name} ${e.teacherId.lastName} (PARALELO ${e.name})')
          ],
          select: (value) {
            final paralelo = listParallel
                .firstWhere((e) => '${e.teacherId.name} ${e.teacherId.lastName} (PARALELO ${e.name})' == value.name);
            setState(() {
              if (parallelIDs.where((e) => e == paralelo).isNotEmpty) {
                parallelIDs = [...parallelIDs];
              } else {
                parallelIDs = [...parallelIDs.where((e) => e.subjectId.id != item.id)];
                parallelIDs = [...parallelIDs, paralelo];
              }
            });
          },
          titleSelect: getTeacherName(item),
        )
    ];
  }

  String getTeacherName(SubjectModel materia) {
    debugPrint('materia ${json.encode(materia)}');
    debugPrint('parallelIDs ${json.encode(parallelIDs)}');
    final parallelName = parallelIDs.where((e) => e.subjectId.id == materia.id).toList();
    debugPrint('parallelName ${json.encode(parallelName)}');
    return parallelName.isNotEmpty
        ? '${parallelName.first.teacherId.name} ${parallelName.first.teacherId.lastName} (PARALELO ${parallelName.first.name})'
        : '';
  }

  createProject() async {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'title': nameCtrl.text.trim(),
      'typeProyect': idTypeProject,
      'category': idCategory,
      'parallelIds': json.encode(parallelIDs),
      'studentIds': studentIds,
    };
    return CafeApi.post(projects(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(json.encode(res.data['project'][0]));
      final project = projectModelFromJson(json.encode(res.data['project'][0]));
      projectBloc.add(AddItemProject(project));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : $e');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  uodateProject() {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'title': nameCtrl.text.trim(),
      'typeProyect': idTypeProject,
      'category': idCategory,
      'parallelIds': json.encode(parallelIDs),
      'studentIds': studentIds,
    };
    return CafeApi.put(projects(widget.item!.project.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final project = projectModelFromJson(json.encode(res.data['project'][0]));
      projectBloc.add(UpdateItemProject(project));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
