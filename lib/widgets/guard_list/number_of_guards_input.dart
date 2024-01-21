import 'package:flutter/material.dart';

class NumberOfGuardsInput extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final int initialState;

  NumberOfGuardsInput({required this.onChanged, required this.initialState});

  @override
  _NumberOfGuardsInputState createState() => _NumberOfGuardsInputState();
}

class _NumberOfGuardsInputState extends State<NumberOfGuardsInput> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

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
          children: List.generate(3, (index) => _buildButton(index + 1, scheme)),
        ),
      ],
    );
  }

  Widget _buildButton(int value, ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedValue == value ? scheme.primary : Colors.grey, // Active color
          foregroundColor: scheme.onPrimary, // Text color
        ),
        onPressed: () {
          setState(() {
            selectedValue = value;
            widget.onChanged(selectedValue);
          });
        },
        child: Text('$value'),
      ),
    );
  }
}
