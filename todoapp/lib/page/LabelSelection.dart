import 'package:flutter/material.dart';
import '../model/Label.dart';

class LabelSelector extends StatefulWidget {
  final List<String> allLabels;
  final Function(List<String>) onLabelsSelected;
  final List<String>? selectedLabels;
  LabelSelector({required this.allLabels, required this.onLabelsSelected,this.selectedLabels});

  @override
  _LabelSelectorState createState() => _LabelSelectorState();
}

class _LabelSelectorState extends State<LabelSelector> {
  List<String> selectedLabels = [];

  @override
  void initState() {
    // TODO: implement initState
    selectedLabels = List<String>.from(widget.selectedLabels??[]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.allLabels.map((label) {
        return CheckboxListTile(
          title: Text(label?? ''),
          value: selectedLabels.contains(label),
          onChanged: (checked) {
            setState(() {
              if (checked!) {
                selectedLabels.add(label);
              } else {
                selectedLabels.remove(label);
              }
              widget.onLabelsSelected(selectedLabels);
            });
          },
        );
      }).toList(),
    );
  }
}
