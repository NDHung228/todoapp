import 'package:flutter/material.dart';
import '../model/Label.dart';

class LabelSelector extends StatefulWidget {
  final List<Label> allLabels;

  LabelSelector({required this.allLabels});

  @override
  _LabelSelectorState createState() => _LabelSelectorState();
}

class _LabelSelectorState extends State<LabelSelector> {
  List<Label> selectedLabels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.allLabels.map((label) {
        return CheckboxListTile(
          title: Text(label.nameLabel ?? ''),
          value: selectedLabels.contains(label),
          onChanged: (checked) {
            setState(() {
              if (checked!) {
                selectedLabels.add(label);
              } else {
                selectedLabels.remove(label);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
