import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SelectMultiple extends StatefulWidget {
  final List<MultiSelectItem<Object?>> items;
  final String labelText;
  final String hintText;
  final Function(List<Object?>) onChanged;
  final List<dynamic> initialValue;
  const SelectMultiple({
    super.key,
    required this.items,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  State<SelectMultiple> createState() => _SelectMultipleState();
}

class _SelectMultipleState extends State<SelectMultiple> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiSelectBottomSheetField(
            initialChildSize: 0.4,
            listType: MultiSelectListType.LIST,
            searchable: true,
            buttonText: Text(widget.hintText),
            title: Text(widget.labelText),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            initialValue: widget.initialValue,
            items: widget.items,
            onConfirm: (values) => widget.onChanged(values),
          ),
        ),
      ],
    );
  }
}
