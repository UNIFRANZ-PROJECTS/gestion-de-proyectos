import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputComponent extends StatelessWidget {
  final IconData? icon;
  final String labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final TextEditingController controllerText;
  final List<TextInputFormatter>? inputFormatters;
  final Function() onEditingComplete;
  final Function(String)? validator;
  final bool obscureText;
  final Function()? onTap;
  final IconData? iconOnTap;
  final TextCapitalization textCapitalization;
  final Function(String)? onChanged;
  final Function()? onTapInput;
  final bool? stateAutofocus;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  const InputComponent(
      {Key? key,
      required this.labelText,
      this.hintText,
      required this.keyboardType,
      required this.textInputAction,
      this.focusNode,
      required this.controllerText,
      this.inputFormatters,
      required this.onEditingComplete,
      this.validator,
      this.icon,
      this.obscureText = false,
      this.onTap,
      this.iconOnTap,
      this.textCapitalization = TextCapitalization.none,
      this.onChanged,
      this.onTapInput,
      this.stateAutofocus = false,
      this.minLines,
      this.maxLines = 1,
      this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: hintText != null ? 8 : 0),
      child: hintText != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [if (hintText != null) Text(labelText), input()],
            )
          : input(),
    );
  }

  Widget input() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        autofocus: stateAutofocus!,
        textAlignVertical: TextAlignVertical.center,
        focusNode: focusNode,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        validator: (text) => validator == null ? null : validator!(text!),
        controller: controllerText,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onTap: onTapInput,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon == null ? null : Icon(icon, color: Colors.grey),
            labelText: hintText == null ? labelText : null,
            suffixIcon: InkWell(
              onTap: onTap,
              child: Icon(
                iconOnTap,
              ),
            )),
      ),
    );
  }
}
