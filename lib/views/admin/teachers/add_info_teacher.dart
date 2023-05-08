import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class AddTeachersData extends StatefulWidget {
  const AddTeachersData({super.key});

  @override
  State<AddTeachersData> createState() => _AddTeachersDataState();
}

class _AddTeachersDataState extends State<AddTeachersData> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  Uint8List? bytes;
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
    FormData formData = FormData.fromMap({
      'archivo': MultipartFile.fromBytes(bytes!),
    });
    return CafeApi.post(teachersXlxs(), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
