import 'package:flutter/cupertino.dart';

class ModalComponent extends StatefulWidget {
  final String title;
  final Widget child;
  final bool back;
  const ModalComponent({super.key, required this.title, required this.child, this.back = true});

  @override
  State<ModalComponent> createState() => _ModalComponentState();
}

class _ModalComponentState extends State<ModalComponent> {
  @override
  Widget build(BuildContext context) {
    // final sizeScreenModal = Provider.of<SizeScreenModal>(context, listen: true).sizeScreen;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: CupertinoPageScaffold(
            child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    // HedersComponent(title: widget.title),
                    Expanded(
                      child: widget.child,
                    )
                  ],
                ))));
  }

  Future<bool> _onBackPressed() async {
    // if (widget.back)
    return true;
    // return await showDialog(context: context, builder: (context) => FadeIn(child: const DialogBack()));
  }
}
