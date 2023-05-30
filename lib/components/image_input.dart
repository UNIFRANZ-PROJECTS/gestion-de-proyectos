import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageInputComponent extends StatefulWidget {
  final bool isImage;
  final bool edit;
  final String? imageFile;
  final Function(String) onPressed;
  final String? defect;
  const ImageInputComponent({
    super.key,
    this.isImage = true,
    this.edit = false,
    this.imageFile,
    required this.onPressed,
    this.defect,
  });

  @override
  State<ImageInputComponent> createState() => _ImageInputComponentState();
}

class _ImageInputComponentState extends State<ImageInputComponent> {
  Uint8List? preview;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => pickerImage(),
        child: Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: preview == null
                    ? widget.defect != null
                        ? widget.isImage
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/gifs/loader.gif',
                                width: 200,
                                height: 200,
                                image: widget.defect!,
                              )
                            : SvgPicture.network(
                                widget.defect!,
                                width: 200,
                                height: 200,
                              )
                        : Image.asset(
                            'assets/images/no-image.jpg',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                          )
                    : SizedBox(
                        width: 200,
                        height: 200,
                        child: widget.imageFile != null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/gifs/loader.gif',
                                image: widget.imageFile!,
                              )
                            : widget.isImage
                                ? Image.memory(preview!)
                                : SvgPicture.memory(preview!))),
            const Positioned(
              bottom: 5,
              right: 0,
              child: Icon(
                Icons.image,
                size: 20,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  pickerImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: widget.isImage ? ['jpg', 'jpeg', 'png'] : ['svg']);

    if (result != null) {
      setState(() => preview = result.files.first.bytes!);
      String base64 = base64Encode(result.files.first.bytes!);
      widget.onPressed(base64);
    } else {
      debugPrint('no hay imagen');
    }
  }
}

class InputXls extends StatefulWidget {
  final bool state;
  final Function(String) onPressed;
  const InputXls({super.key, required this.onPressed, this.state = false});

  @override
  State<InputXls> createState() => _InputXlsState();
}

class _InputXlsState extends State<InputXls> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickerfile(),
      child: Icon(
        Icons.image,
        size: 80,
        color: widget.state ? Colors.green : Colors.grey,
      ),
    );
  }

  pickerfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

    if (result != null) {
      String base64 = base64Encode(result.files.first.bytes!);
      widget.onPressed(base64);
    } else {
      debugPrint('no hay file');
    }
  }
}
