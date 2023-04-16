import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  final String labelText;
  final String hintText;
  final List<String> options;
  final Function(String) onChanged;
  final bool statecorrect;
  final String? text;
  const Select(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.options,
      required this.onChanged,
      this.statecorrect = false,
      this.text})
      : super(key: key);

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: widget.statecorrect
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: const Color(0xff27AE60)))
                : BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey, width: 0.5)),
            child: DropdownButton(
              dropdownColor: const Color(0xffEBEDEE),
              underline: Container(),
              isExpanded: true,
              hint: Text(
                widget.text ?? 'Seleccione una opción',
                style: const TextStyle(color: Colors.grey),
              ),
              borderRadius: BorderRadius.circular(10.0),
              elevation: 0,
              items: widget.options.map(
                (val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val));
                },
              ).toList(),
              onChanged: (val) {
                widget.onChanged(val!);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SelectMultipe extends StatelessWidget {
  const SelectMultipe({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
