import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarComponent extends StatelessWidget {
  final bool isFromDate;
  final DateTime? date;
  final Function(DateTime) onDateChanged;

  const CalendarComponent({
    super.key,
    required this.isFromDate,
    required this.date,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            hintText: date == null
                ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                : DateFormat('dd-MM-yyyy').format(date!),
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      onDateChanged(selectedDate);
    }
  }
}