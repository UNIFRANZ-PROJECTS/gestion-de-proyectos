import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';

class SelectComponent extends StatefulWidget {
  final String title;
  final String subtitle;
  final List options;
  final String? defect;
  final Function(String) values;
  final String? textError;
  final bool error;
  const SelectComponent(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.options,
      this.defect,
      required this.values,
      this.textError,
      this.error = false})
      : super(key: key);

  @override
  State<SelectComponent> createState() => _SelectComponentState();
}

class _SelectComponentState extends State<SelectComponent> {
  TextEditingController textControllerNameCategory = TextEditingController();
  String? selectItem;
  @override
  void initState() {
    super.initState();

    setState(() {
      selectItem = widget.subtitle;
      if (widget.defect != null) {
        debugPrint('sds ${widget.options[0].name}');
        // selectItem = widget.options.firstWhere((e) => e.id == widget.defect).name ?? 'no';
        selectItem = widget.defect;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> listalista = [...widget.options.map((e) => e.name)];
    listalista.sort((a, b) => a.compareTo(b));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => onTextFieldTap(listalista.map((val) => SelectedListItem(name: val)).toList()),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xffEBEDEE),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.red)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                  child: Text(selectItem!),
                )),
          ),
          if (widget.error)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Text(
                widget.textError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  onTextFieldTap(List<SelectedListItem> data) {
    DropDownState(
      DropDown(
        bottomSheetTitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        data: data,
        selectedItems: (List<dynamic> selectedList) {
          final value = widget.options.firstWhere((e) => e.name == selectedList[0].name);
          setState(() => selectItem = selectedList[0].name.toString());
          widget.values(value.id);
        },
      ),
    ).showModal(context);
  }
}
