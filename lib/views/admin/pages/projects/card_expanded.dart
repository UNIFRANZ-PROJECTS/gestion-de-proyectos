import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:printing/printing.dart';

class CardExpanded extends StatefulWidget {
  final ProjectModel project;
  const CardExpanded({Key? key, required this.project}) : super(key: key);

  @override
  State<CardExpanded> createState() => _CardExpandedState();
}

class _CardExpandedState extends State<CardExpanded> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController objectiveCtrl = TextEditingController();
  TextEditingController problemCtrl = TextEditingController();
  bool modeEdit = false;
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: true)
        .state
        .listProject
        .firstWhere((e) => e.project.id == widget.project.project.id);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        body: GestureDetector(
          child: Center(
            child: Hero(
                tag: 'flipcardHero${projectBloc.project.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: GestureDetector(
                      onTap: () {},
                      child: ContainerComponent(
                          radius: (size.width > 1000) ? 30 : 0,
                          height: (size.width > 1000) ? sizeHeight / 1.5 : size.height,
                          width: (size.width > 1000) ? MediaQuery.of(context).size.width / 1.1 : size.width,
                          child: (size.width > 1000)
                              ? Row(
                                  children: cards(sizeHeight, projectBloc),
                                )
                              : const Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    // EventDetailBackground(event: widget.project),
                                    // EventDetailsContent(
                                    //   event: widget.project,
                                    //   onPressed: () => loginshow(context),
                                    // ),
                                  ],
                                ))),
                )),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  List<Widget> cards(double sizeHeight, ProjectModel projectBloc) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            // borderRadius: const BorderRadius.all(
            //   Radius.circular(30),
            // ),
            child: Image.asset(
              'assets/images/logo-bronce.png',
              height: sizeHeight / 1.5,
              // fit: BoxFit.,
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: modeEdit
              ? Form(
                  key: formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: inputs(),
                  )))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Text(projectBloc.project.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
                    const SizedBox(height: 8),
                    const Text(
                      'Objetivo General:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Flexible(child: Text(projectBloc.project.generalObjective)),
                    const SizedBox(height: 8),
                    const Text(
                      'Problema de la investigación:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Flexible(child: Text(projectBloc.project.researchProblem)),
                    // for (final key in projectBloc.materias)
                    //   Row(
                    //     children: [Text(key.subjectId.name), Text(key.teacherId.name)],
                    //   ),
                    Row(
                      children: [
                        Expanded(
                            child: ButtonComponent(
                                text: 'EDITAR',
                                onPressed: () => setState(() {
                                      modeEdit = true;
                                      objectiveCtrl.text = projectBloc.project.generalObjective;
                                      problemCtrl.text = projectBloc.project.researchProblem;
                                    }))),
                        IconButton(
                            icon: const Icon(Icons.print, color: Colors.green), onPressed: () => printDocument()),
                      ],
                    )
                  ],
                ),
        ),
      ),
    ];
  }

  List<Widget> inputs() {
    return [
      Flexible(
          child: Text(widget.project.project.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
      const SizedBox(height: 8),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: objectiveCtrl,
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Objetivo General';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Objetivo General:",
          hintText: "Objetivo General"),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: problemCtrl,
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Problema de la investigación';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Problema de la investigación:",
          hintText: "Problema de la investigación"),
      ButtonComponent(text: 'GUARDAR', onPressed: () => saveChanges(context))
    ];
  }

  printDocument() {
    debugPrint('obteniendo documento');
    CafeApi.configureDio();
    return CafeApi.httpGet(documentProject(widget.project.project.id)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['base64'])}');
      final bytes = base64Decode(res.data['base64']);
      await Printing.sharePdf(bytes: bytes, filename: 'documento.xlsx');
    });
  }

  saveChanges(BuildContext context) {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'generalObjective': objectiveCtrl.text.trim(),
      'researchProblem': problemCtrl.text.trim(),
    };
    return CafeApi.put(projects(widget.project.project.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(json.encode(res.data['project'][0]));
      final project = projectModelFromJson(json.encode(res.data['project'][0]));
      projectBloc.add(UpdateItemProject(project));
      setState(() => modeEdit = false);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
