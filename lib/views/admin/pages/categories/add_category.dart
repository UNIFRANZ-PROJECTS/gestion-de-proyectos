import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddCategoryForm extends StatefulWidget {
  final ElementModel? item;
  const AddCategoryForm({super.key, this.item});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const HedersComponent(
                title: 'Nuevo Tipo de usuario',
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
                      ? ButtonComponent(text: 'Crear Categoria', onPressed: () => createCategory())
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

  createCategory() async {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(categories(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      categoryBloc.add(AddItemCategory(elementModelFromJson(json.encode(res.data['categoria']))));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() async {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(categories(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final element = elementModelFromJson(json.encode(res.data['categoria']));
      categoryBloc.add(UpdateItemCategory(element));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
