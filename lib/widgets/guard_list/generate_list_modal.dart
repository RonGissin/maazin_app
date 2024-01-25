import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../datetime_picker.dart';
import 'number_of_guards_input.dart';
import 'package:flutter/cupertino.dart';

class GenerateListModal extends StatefulWidget {
  final DateTime previousStartTime;
  final DateTime previousEndTime;
  final Function(String, DateTime, DateTime, int?, int, bool) onGenerateList;
  final void Function(DateTime) onSetStartTime;
  final void Function(DateTime) onSetEndTime;

  const GenerateListModal({
    Key? key,
    required this.previousStartTime,
    required this.previousEndTime,
    required this.onGenerateList,
    required this.onSetStartTime,
    required this.onSetEndTime,
  }) : super(key: key);

  @override
  _GenerateListModalState createState() => _GenerateListModalState();
}

class _GenerateListModalState extends State<GenerateListModal> {
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  bool isInvalidTime = false;
  int numberOfConcurrentGuards = 1;
  int? intGuardTime;
  final TextEditingController doubleGuardTimeController = TextEditingController();
  final TextEditingController listNameController = TextEditingController();
  bool isFixedGuardTime = false;

  @override
  void initState() {
    super.initState();
    selectedStartTime = widget.previousStartTime;
    selectedEndTime = widget.previousEndTime;
  }

  void _showFixedTimeInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'When fixed guard time is toggled on, each team member might guard more than once if needed (cycles).',
            style: TextStyle(fontSize: 17.0)          
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Configure your watch',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: listNameController,
            decoration: const InputDecoration(labelText: 'List Name'),
          ),
          const SizedBox(height: 20.0),
          DateTimePicker(
            label: 'Start Time',
            initialTime: widget.previousStartTime,
            onTimeChanged: (DateTime time) {
              setState(() {
                selectedStartTime = time;
              });

              widget.onSetStartTime(time);
            },
          ),
          const SizedBox(height: 20.0),
          DateTimePicker(
            label: 'End Time',
            initialTime: widget.previousEndTime,
            onTimeChanged: (DateTime time) {
              setState(() {
                selectedEndTime = time;
                isInvalidTime = selectedStartTime.isAfter(selectedEndTime);
              });

              widget.onSetEndTime(time);
            },
          ),
          const SizedBox(height: 20.0),
          Visibility(
            visible: isInvalidTime,
            child: Text(
              'End time cannot be earlier than start time',
              style: TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 20.0),
          NumberOfGuardsInput(
            initialState: numberOfConcurrentGuards,
            onChanged: (value) {
              setState(() {
                numberOfConcurrentGuards = value;
              });
            },
          ),
          const SizedBox(height: 25.0),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.0, left: 5.0),
                child: Switch(
                  value: isFixedGuardTime,
                  onChanged: (value) {
                    setState(() {
                      isFixedGuardTime = value;
                    });
                  },
              )),
              Text('Fixed Guard Time'),
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  _showFixedTimeInfoDialog(context);
                },
              ),
            ],
          ),
          Visibility(
            visible: isFixedGuardTime,
            child: Center(
              child: Container(
                height: 100.0, 
                width: 250.0, // Fixed width for the picker
                child: CupertinoPicker(
                  selectionOverlay: CupertinoPickerDefaultSelectionOverlay(background: scheme.primary.withOpacity(0.5)),
                  magnification: 1.2,
                  diameterRatio: 1.1,
                  itemExtent: 32.0, // Height of each item
                  onSelectedItemChanged: (int value) {
                    setState(() {
                      intGuardTime = value;
                    });
                  },
                  children: List<Widget>.generate(200, (int index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          index.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          ' min',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(scheme.secondary),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    isInvalidTime = selectedStartTime.isAfter(selectedEndTime);
                  });
                  // Perform validation
                  if (isInvalidTime) {
                    return;
                  }

                  var listName = listNameController.text.trim();

                  widget.onGenerateList(
                    listName,
                    selectedStartTime,
                    selectedEndTime,
                    isFixedGuardTime ? intGuardTime : null,
                    numberOfConcurrentGuards,
                    isFixedGuardTime,
                  );
                },
                child: const Text('Generate'),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
