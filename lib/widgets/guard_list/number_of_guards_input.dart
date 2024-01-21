import 'package:flutter/material.dart';

class NumberOfGuardsInput extends StatefulWidget {
  final ValueChanged<int> onChanged;
  int initialState = 1;

  NumberOfGuardsInput({required this.onChanged, required this.initialState});

  @override
  _NumberOfGuardsInputState createState() => _NumberOfGuardsInputState(initialState);
}

class _NumberOfGuardsInputState extends State<NumberOfGuardsInput> {
  _NumberOfGuardsInputState(int intitialState)
  {
    selectedValue = intitialState;
  }

  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Number of Guards',
            style: TextStyle(fontSize: 16.0),
        )),
        Row(
          children: [
            Radio(
              value: 1,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                  widget.onChanged(selectedValue);
                });
              },
            ),
            const Text('1'),
            Radio(
              value: 2,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                  widget.onChanged(selectedValue);
                });
              },
            ),
            const Text('2'),
            Radio(
              value: 3,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value as int;
                  widget.onChanged(selectedValue);
                });
              },
            ),
            const Text('3'),
          ],
        ),
      ],
    );
  }
}
