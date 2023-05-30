import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SelectMultiple extends StatelessWidget {
  final List<MultiSelectItem<Object?>> items;
  final String labelText;
  final String hintText;
  final String? textError;
  // final bool error;
  final Function(List<Object?>) onChanged;
  final List<dynamic> initialValue;
  const SelectMultiple({
    super.key,
    required this.items,
    required this.labelText,
    required this.hintText,
    this.textError,
    required this.onChanged,
    required this.initialValue,
    // required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: MultiSelectBottomSheetField(
            initialChildSize: 0.4,
            listType: MultiSelectListType.LIST,
            searchable: true,
            buttonText: Text(hintText),
            title: Text(labelText),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
            initialValue: initialValue,
            items: items,
            onConfirm: (values) => onChanged(values),
          ),
        ),
        // if (error)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 13.0),
        //     child: Text(
        //       textError!,
        //       style: const TextStyle(color: Colors.red),
        //     ),
        //   ),
      ],
    );
  }
}
