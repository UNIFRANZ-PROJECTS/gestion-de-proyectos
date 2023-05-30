import 'package:flutter/material.dart';
import 'package:gestion_projects/components/compoents.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controllerText;
  final Function(String) onChanged;
  final bool isWhite;
  const SearchWidget({
    super.key,
    required this.controllerText,
    required this.onChanged,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return InputComponent(
      textInputAction: TextInputAction.done,
      controllerText: controllerText,
      onChanged: (value) => onChanged(value),
      onEditingComplete: () {},
      validator: (value) {
        if (value.isNotEmpty) {
          return null;
        } else {
          return 'complemento';
        }
      },
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.characters,
      icon: Icons.search,
      labelText: "Buscar",
    );
  }
}
