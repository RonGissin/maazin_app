import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maazin_app/utils/date_formatter.dart';

class DateTimePicker extends StatefulWidget {
  final String label;
  final DateTime initialTime;
  final ValueChanged<DateTime> onTimeChanged;

  const DateTimePicker({
    Key? key,
    required this.label,
    required this.initialTime,
    required this.onTimeChanged,
  }) : super(key: key);

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

  void _showCupertinoModal(BuildContext context, {required Widget picker}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.4, // Adjust the height as needed
        child: Column(
          children: [
            SizedBox(
              height: 50, // Height for the OK button and padding
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10), 
                      child: TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(10),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onTimeChanged(selectedTime);
                      },
                      child: const Text('OK', style: TextStyle(fontSize: 18)),
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: picker,
            ),
          ],
        ),
      ),
    );
  }


  void _showCupertinoDatePicker(BuildContext context) {
    _showCupertinoModal(
      context,
      picker: CupertinoDatePicker(
        dateOrder: DatePickerDateOrder.dmy,
        mode: CupertinoDatePickerMode.date,
        initialDateTime: selectedTime,
        minimumDate: DateTime(2000),
        maximumDate: DateTime(2101),
        showDayOfWeek: true,
        onDateTimeChanged: (DateTime newDate) {
          // Only change the date part of selectedTime
          setState(() {
            selectedTime = DateTime(
              newDate.year,
              newDate.month,
              newDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
          });
        },
      ),
    );
  }

  void _showCupertinoTimePicker(BuildContext context) {
    _showCupertinoModal(
      context,
      picker: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        initialDateTime: selectedTime,
        onDateTimeChanged: (DateTime newTime) {
          // Only change the time part of selectedTime
          setState(() {
            selectedTime = DateTime(
              selectedTime.year,
              selectedTime.month,
              selectedTime.day,
              newTime.hour,
              newTime.minute,
            );
          });
          widget.onTimeChanged(selectedTime);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            _showCupertinoDatePicker(context);
          },
          child: Text(
            '${selectedTime.toLocal()}'.split(' ')[0],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showCupertinoTimePicker(context);
          },
          child: Text(
            DateFormatter.formatTime(selectedTime),
          ),
        ),
      ],
    );
  }
}
