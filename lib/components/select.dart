import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class Select extends StatelessWidget {
  final String title;
  final List<String> options;
  final String titleSelect;
  final String? textError;
  final bool error;
  final Function(dynamic) select;
  const Select({
    super.key,
    required this.title,
    required this.options,
    required this.titleSelect,
    this.textError,
    this.error = false,
    required this.select,
  });

  @override
  Widget build(BuildContext context) {
    options.sort((a, b) => a.compareTo(b));
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => onTextFieldTap(context, options.map((val) => SelectedListItem(name: val)).toList()),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xffEBEDEE),
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.red)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                    child: Text(titleSelect),
                  )),
            ),
            if (error)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Text(
                  textError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  onTextFieldTap(BuildContext context, List<SelectedListItem> data) {
    DropDownState(
      DropDown(
        bottomSheetTitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        data: data,
        selectedItems: (List<dynamic> selectedList) => select(selectedList[0]),
      ),
    ).showModal(context);
  }
}
