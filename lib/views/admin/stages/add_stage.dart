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

class AddStage extends StatefulWidget {
  final StageModel? item;
  const AddStage({super.key, this.item});

  @override
  State<AddStage> createState() => _AddStageState();
}

class _AddStageState extends State<AddStage> {
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
            children: [
              const HedersComponent(
                title: 'Nuevo Tipo de proyecto',
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
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Categoria', onPressed: () => createStage())
                      : ButtonComponent(text: 'Actualizar Categoria', onPressed: () => updateCategory())
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

  createStage() async {
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    FormData formData = FormData.fromMap({
      'name': "asdasdsadsd",
      'start': "2023-05-08 09:00:00.000",
      'end': "2023-05-08 09:00:00.000",
      'weighing': 123,
      'requirementIds': ["64592101914edac991a47af8", "645921133d7dc7ca0bdb1667"]
    });
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(typeProjects(null), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      stageBloc.add(AddItemStage(stageModelFromJson(json.encode(res.data['etapa']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() async {
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    FormData formData = FormData.fromMap({
      'name': "asdasdsadsd",
      'start': "2023-05-08 09:00:00.000",
      'end': "2023-05-08 09:00:00.000",
      'weighing': 123,
      'requirementIds': ["64592101914edac991a47af8", "645921133d7dc7ca0bdb1667"]
    });
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(typeProjects(widget.item!.id), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final element = stageModelFromJson(json.encode(res.data['etapa']));
      stageBloc.add(UpdateItemStage(element));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
