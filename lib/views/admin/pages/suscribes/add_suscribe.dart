import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:printing/printing.dart';

class AddSuscribeForm extends StatefulWidget {
  final double price;
  final SuscribeModel? item;
  const AddSuscribeForm({super.key, required this.price, this.item});

  @override
  State<AddSuscribeForm> createState() => _AddSuscribeFormState();
}

class _AddSuscribeFormState extends State<AddSuscribeForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController(text: '0.0');
  bool stateLoading = false;
  double change = 0.0;
  String? idSuscribe;
  String textSuscribe = '';
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // setState(() {
      //   nameCtrl = TextEditingController(text: widget.item!.name);
      // });
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
                title: 'Nueva Inscripción',
                initPage: false,
              ),
              Text('El monto a pagar es ${widget.price} Bs'),
              (size.width > 1000)
                  ? Row(children: titleName())
                  : Column(mainAxisSize: MainAxisSize.min, children: titleName()),
              !stateLoading
                  ? ButtonComponent(
                      text: 'Inscribir', onPressed: () => widget.item == null ? createSuscribe() : editsuscribe())
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

  List<Widget> titleName() {
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: true).state.listUser.toList();
    return [
      Select(
        title: 'Estudiante:',
        options: [...suscribeBloc.map((e) => '${e.name} ${e.lastName}')],
        textError: 'Seleccióna el estudiante',
        select: (value) {
          final item = suscribeBloc.firstWhere((e) => '${e.name} ${e.lastName}' == value.name);
          setState(() {
            idSuscribe = item.id;
            textSuscribe = '${item.name} ${item.lastName}';
          });
        },
        titleSelect: textSuscribe,
      ),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: nameCtrl,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")), LengthLimitingTextInputFormatter(100)],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'Importe';
            }
          },
          onChanged: (v) {
            setState(() {
              change = double.parse(v) - widget.price;
            });
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Importe:",
          hintText: "Importe"),
      Flexible(child: Text('Importe devuelto: $change')),
    ];
  }

  createSuscribe() async {
    debugPrint('Inscribiendo');
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false).state.listSeason.firstWhere((e) => e.state);
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'season': seasonBloc.id,
      'student': idSuscribe,
      'total': nameCtrl.text.trim(),
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(suscribeStudent(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final suscribe = suscribeModelFromJson(json.encode(res.data['studentSuscribe']));
      suscribeBloc.add(AddItemSuscribe(suscribe));
      suscribeBloc.add(RemoveItemStudentDebt(idSuscribe!));
      debugPrint(' ressssss ${json.encode(res.data['document'])}');
      final bytes = base64Decode(res.data['document']);
      await Printing.sharePdf(bytes: bytes, filename: 'documento.pdf');

      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  editsuscribe() async {}
}
