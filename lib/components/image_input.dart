import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageInputComponent extends StatefulWidget {
  final bool edit;
  final String? imageFile;
  final Function(Uint8List) onPressed;
  final String? defect;
  const ImageInputComponent({
    super.key,
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
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/gifs/loader.gif',
                            width: 200,
                            height: 200,
                            image: widget.defect!,
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
                            : Image.memory(preview!))),
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result != null) {
      setState(() => preview = result.files.first.bytes!);
      widget.onPressed(result.files.first.bytes!);
    } else {
      debugPrint('no hay imagen');
    }
  }
}

class SvgInputComponent extends StatefulWidget {
  final bool edit;
  final String? imageFile;
  final Function(Uint8List) onPressed;
  final String? defect;
  const SvgInputComponent({
    super.key,
    this.edit = false,
    this.imageFile,
    required this.onPressed,
    this.defect,
  });

  @override
  State<SvgInputComponent> createState() => _SvgInputComponentState();
}

class _SvgInputComponentState extends State<SvgInputComponent> {
  Uint8List? preview;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => pickerImage(),
        child: Stack(
          children: <Widget>[
            preview == null
                ? widget.defect != null
                    ? SvgPicture.network(
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
                        : SvgPicture.memory(preview!)),
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['svg']);

    if (result != null) {
      setState(() => preview = result.files.first.bytes!);
      widget.onPressed(result.files.first.bytes!);
    } else {
      debugPrint('no hay imagen');
    }
  }
}

class InputXls extends StatefulWidget {
  final bool state;
  final Function(Uint8List) onPressed;
  const InputXls({super.key, required this.onPressed, this.state = false});

  @override
  State<InputXls> createState() => _InputXlsState();
}

class _InputXlsState extends State<InputXls> {
  Uint8List? preview;
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
      setState(() => preview = result.files.first.bytes!);
      widget.onPressed(result.files.first.bytes!);
    } else {
      debugPrint('no hay file');
    }
  }
}
