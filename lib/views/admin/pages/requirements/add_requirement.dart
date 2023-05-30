import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddRequirement extends StatefulWidget {
  final RequirementModel? item;
  const AddRequirement({super.key, this.item});

  @override
  State<AddRequirement> createState() => _AddRequirementState();
}

class _AddRequirementState extends State<AddRequirement> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  bool stateLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        descriptionCtrl = TextEditingController(text: widget.item!.description);
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
                title: 'Nuevo Requerimiento',
                initPage: false,
              ),
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
                      return 'Nombre';
                    }
                  },
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  labelText: "Nombre:",
                  hintText: null),
              InputComponent(
                  textInputAction: TextInputAction.done,
                  controllerText: descriptionCtrl,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z áéíóúñÁÉÍÓÚÑ]")),
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
                  labelText: "Descripción:",
                  hintText: null),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Requisito', onPressed: () => createRequirement())
                      : ButtonComponent(text: 'Actualizar Requisito', onPressed: () => updateRequirement())
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

  createRequirement() async {
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      "name": nameCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(requirements(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      requirementBloc.add(AddItemRequirement(requirementModelFromJson(json.encode(res.data['requisito']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateRequirement() async {
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(requirements(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final element = requirementModelFromJson(json.encode(res.data['requisito']));
      requirementBloc.add(UpdateItemRequirement(element));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
