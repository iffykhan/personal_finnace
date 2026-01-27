import 'package:flutter/material.dart';

class AddTransactionScreenDialogue<t> extends StatelessWidget {

  final List<t> list;
  final String Function(t) label;
  final void Function(t) onSelect;

  const AddTransactionScreenDialogue(
      {super.key,
      required this.list,
      required this.label,
      required this.onSelect,
      });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children:   list.map((element){
              return ListTile(
                title: Text(label(element)),
                onTap: () {
                  onSelect(element);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
