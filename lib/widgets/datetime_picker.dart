import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final String label;
  final DateTime initialTime;
  final ValueChanged<DateTime> onTimeChanged;

  const DateTimePicker({
    required this.label,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () async {
            DateTime? pickedDateTime = await showDatePicker(
              context: context,
              initialDate: selectedTime,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDateTime != null) {
              TimeOfDay? pickedHourMinute = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(selectedTime),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );

              if (pickedHourMinute != null) {
                DateTime selectedDateTime = DateTime(
                  pickedDateTime.year,
                  pickedDateTime.month,
                  pickedDateTime.day,
                  pickedHourMinute.hour,
                  pickedHourMinute.minute,
                );

                setState(() {
                  selectedTime = selectedDateTime;
                });

                widget.onTimeChanged(selectedDateTime);
              }
            }
          },
          child: Text(
            '${selectedTime.toLocal()}'.split(' ')[0] +
                ' ${selectedTime.toLocal().hour.toString().padLeft(2, '0')}:${selectedTime.toLocal().minute.toString().padLeft(2, '0')}',
          ),
        ),
      ],
    );
  }
}