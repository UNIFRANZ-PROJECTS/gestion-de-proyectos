import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_projects/provider/auth_provider.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:provider/provider.dart';

import 'package:gestion_projects/components/compoents.dart';

class DialogLogin extends StatefulWidget {
  const DialogLogin({Key? key}) : super(key: key);

  @override
  State<DialogLogin> createState() => _DialogLoginState();
}

class _DialogLoginState extends State<DialogLogin> {
  bool stateLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCtrl = TextEditingController(text: 'carlos@gmail.com');
  TextEditingController passwordCtrl = TextEditingController(text: 'carlos123');
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return FadeIn(
        child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: const Text(
        'Inicio de sesión',
        textAlign: TextAlign.center,
      ),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputComponent(
                textInputAction: TextInputAction.done,
                controllerText: emailCtrl,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z.@]"))],
                onEditingComplete: () {},
                validator: (value) {
                  if (value.isNotEmpty) {
                    if (value.contains("@") && value.contains(".com")) {
                      return null;
                    } else {
                      return 'ingrese su correo valido';
                    }
                  } else {
                    return 'ingrese su correo';
                  }
                },
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.characters,
                icon: Icons.search,
                labelText: "Correo",
              ),
              const SizedBox(
                height: 10,
              ),
              InputComponent(
                  textInputAction: TextInputAction.done,
                  controllerText: passwordCtrl,
                  onEditingComplete: () => initSession(),
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (value.length >= 6) {
                        return null;
                      } else {
                        return 'Debe tener un mínimo de 6 caracteres.';
                      }
                    } else {
                      return 'Ingrese su contraseña';
                    }
                  },
                  // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.text,
                  icon: Icons.lock,
                  labelText: "Contraseña",
                  obscureText: hidePassword,
                  onTap: () => setState(() => hidePassword = !hidePassword),
                  iconOnTap: hidePassword ? Icons.lock_outline : Icons.lock_open_sharp),
            ],
          )),
      actions: [
        !stateLoading
            ? ButtonComponent(text: 'INGRESAR', onPressed: () => initSession())
            : Center(
                child: Image.asset(
                'assets/gifs/load.gif',
                fit: BoxFit.cover,
                height: 20,
              ))
      ],
    ));
  }

  initSession() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      setState(() => stateLoading = !stateLoading);
      FormData formData = FormData.fromMap({
        'email': emailCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
      });
      return CafeApi.post(setLogin(), formData).then((res) async {
        setState(() => stateLoading = !stateLoading);
        authProvider.login(res);
      }).catchError((e) {
        setState(() => stateLoading = !stateLoading);
        debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
        callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
      });
    }
  }
}
