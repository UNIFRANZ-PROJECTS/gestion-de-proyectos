import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddStage extends StatefulWidget {
  final StageModel? item;
  const AddStage({super.key, this.item});

  @override
  State<AddStage> createState() => _AddStageState();
}

class _AddStageState extends State<AddStage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController weighingCtrl = TextEditingController();
  bool stateLoading = false;
  String hintTextTimeStart = '';
  DateTime startTime = DateTime.now();
  String hintTextTimeEnd = '';
  DateTime endTime = DateTime.now();
  List<String> requirementIds = [];
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        weighingCtrl = TextEditingController(text: '${widget.item!.weighing}');
        startTime = widget.item!.start;
        endTime = widget.item!.end;
        hintTextTimeStart = DateFormat(' dd, MMMM yyyy ').format(widget.item!.start);
        hintTextTimeEnd = DateFormat(' dd, MMMM yyyy ').format(widget.item!.end);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HedersComponent(
                title: 'Nueva Etapa',
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: inputs01())
                  : Column(mainAxisSize: MainAxisSize.min, children: inputs01()),
              (size.width > 1000)
                  ? Row(children: inputs02())
                  : Column(mainAxisSize: MainAxisSize.min, children: inputs02()),
              inputs03(),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Etapa', onPressed: () => createStage())
                      : ButtonComponent(text: 'Actualizar Etapa', onPressed: () => updateCategory())
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

  List<Widget> inputs01() {
    return [
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: nameCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z áéíóúñÁÉÍÓÚÑ]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'complemento';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Nombre:",
          hintText: null),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: weighingCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(100)],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'complemento';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Ponderación:",
          hintText: null),
    ];
  }

  List<Widget> inputs02() {
    return [
      DateTimeWidget(
        labelText: 'Fecha inicio:',
        hintText: hintTextTimeStart,
        selectTime: (value) => setState(() {
          hintTextTimeStart = DateFormat(' dd, MMMM yyyy ').format(value);
          startTime = value;
        }),
      ),
      DateTimeWidget(
        labelText: 'Fecha fin:',
        hintText: hintTextTimeEnd,
        selectTime: (value) => setState(() {
          hintTextTimeEnd = DateFormat(' dd, MMMM yyyy ').format(value);
          endTime = value;
        }),
      ),
    ];
  }

  Widget inputs03() {
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: true).state;

    final requirements =
        requirementBloc.listRequirement.map((e) => MultiSelectItem<RequirementModel>(e, e.name)).toList();
    List<RequirementModel> filteredList = [];
    if (widget.item != null) {
      // filteredList =
      //     requirementBloc.listRequirement.where((e) => widget.item!.permisionIds.any((i) => i.id == e.id)).toList();
    }
    return Flexible(
        child: SelectMultiple(
      initialValue: widget.item != null ? filteredList : const [],
      items: requirements,
      labelText: 'Requisito(s):',
      hintText: 'Requisito(s)',
      onChanged: (values) =>
          setState(() => requirementIds = values.map((e) => requirementModelFromJson(json.encode(e)).id).toList()),
    ));
  }

  createStage() async {
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'start': '$startTime',
      'end': '$endTime',
      'weighing': int.parse(weighingCtrl.text.trim()),
      'requirementIds': requirementIds
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(stages(null), body).then((res) async {
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
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'start': '$startTime',
      'end': '$endTime',
      'weighing': int.parse(weighingCtrl.text.trim()),
      'requirementIds': requirementIds
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(stages(widget.item!.id), body).then((res) async {
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
