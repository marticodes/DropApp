import 'package:flutter/material.dart';

class TimePickerComponent extends StatelessWidget {
  final bool isFromTime;
  final TimeOfDay? time;
  final ValueChanged<TimeOfDay?> onTimeChanged;

  const TimePickerComponent({
    super.key,
    required this.isFromTime,
    required this.time,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickTime(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            hintText: time == null
                ? TimeOfDay.now().format(context)
                : time!.format(context),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: const TimePickerThemeData(
              hourMinuteTextStyle: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
              dayPeriodColor:  Color.fromRGBO(108, 106, 157, 1), // AM/PM button color
              dialHandColor:  Color.fromRGBO(108, 106, 157, 1), // Dial hand color
              dialTextStyle:  TextStyle(),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedTime != null) {
      onTimeChanged(selectedTime);
    }
  }
}
