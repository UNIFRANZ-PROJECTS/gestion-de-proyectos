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

class AddSeason extends StatefulWidget {
  final SeasonModel? item;
  const AddSeason({super.key, this.item});

  @override
  State<AddSeason> createState() => _AddSeasonState();
}

class _AddSeasonState extends State<AddSeason> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  bool stateLoading = false;
  String hintTextTimeStart = '';
  DateTime startTime = DateTime.now();
  String hintTextTimeEnd = '';
  DateTime endTime = DateTime.now();
  List<String> stageIds = [];
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        priceCtrl = TextEditingController(text: '${widget.item!.price}');
        startTime = widget.item!.start;
        endTime = widget.item!.end;
        hintTextTimeStart = DateFormat(' dd, MMMM yyyy ').format(widget.item!.start);
        hintTextTimeEnd = DateFormat(' dd, MMMM yyyy ').format(widget.item!.end);
        stageIds = [...widget.item!.stagesIds.map((e) => e.id)];
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
                title: 'Nueva temporada',
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: inputs01())
                  : Column(mainAxisSize: MainAxisSize.min, children: inputs01()),
              (size.width > 1000)
                  ? Row(children: inputs02())
                  : Column(mainAxisSize: MainAxisSize.min, children: inputs02()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Temporada', onPressed: () => createCategory())
                      : ButtonComponent(text: 'Actualizar Temporada', onPressed: () => updateCategory())
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
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: true).state;

    final stages = stageBloc.listStage.map((e) => MultiSelectItem<StageModel>(e, e.name)).toList();
    List<RequirementModel> filteredList = [];
    if (widget.item != null) {
      // filteredList =
      //     requirementBloc.listRequirement.where((e) => widget.item!.permisionIds.any((i) => i.id == e.id)).toList();
    }
    return [
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: nameCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z áéíóúñÁÉÍÓÚÑ./]")),
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
          labelText: "Temporada:",
          hintText: null),
      Flexible(
          child: SelectMultiple(
        initialValue: widget.item != null ? filteredList : const [],
        items: stages,
        labelText: 'Etapas(s):',
        hintText: 'Etapas(s)',
        onChanged: (values) =>
            setState(() => stageIds = values.map((e) => stageModelFromJson(json.encode(e)).id).toList()),
      ))
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
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: priceCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(100)],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'complemento';
            }
          },
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.characters,
          labelText: "Precio:",
          hintText: null),
    ];
  }

  createCategory() async {
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "start": '$startTime',
      "end": '$endTime',
      "stagesIds": stageIds,
      "price": double.parse(priceCtrl.text.trim())
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(seasons(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      seasonBloc.add(AddItemSeason(seasonModelFromJson(json.encode(res.data['temporada']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() async {
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "start": '$startTime',
      "end": '$endTime',
      "stagesIds": stageIds,
      "price": double.parse(priceCtrl.text.trim())
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(seasons(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final element = seasonModelFromJson(json.encode(res.data['temporada']));
      seasonBloc.add(UpdateItemSeason(element));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
