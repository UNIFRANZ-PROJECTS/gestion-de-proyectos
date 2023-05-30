import 'package:flutter/material.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddSubjectsData extends StatefulWidget {
  const AddSubjectsData({super.key});

  @override
  State<AddSubjectsData> createState() => _AddSubjectsDataState();
}

class _AddSubjectsDataState extends State<AddSubjectsData> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  String? bytes;
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const HedersComponent(
            title: 'Subir excel',
            initPage: false,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputXls(
                  onPressed: (imageBytes) => setState(() => bytes = imageBytes),
                  state: bytes == null ? false : true,
                ),
                !stateLoading
                    ? ButtonComponent(text: 'Cargar datos', onPressed: () => submitData())
                    : Center(
                        child: Image.asset(
                        'assets/gifs/load.gif',
                        fit: BoxFit.cover,
                        height: 20,
                      ))
              ],
            ),
          ),
        ]));
  }

  submitData() async {
    CafeApi.configureDio();
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'archivo': bytes,
    };
    return CafeApi.post(subjectsXlxs(), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
