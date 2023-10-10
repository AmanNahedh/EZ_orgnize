import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayInputWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const BirthdayInputWidget({required this.onDateSelected});

  @override
  _BirthdayInputWidgetState createState() => _BirthdayInputWidgetState();
}

class _BirthdayInputWidgetState extends State<BirthdayInputWidget> {
  late DateTime selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Birthday',
          style: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatter.format(selectedDate),
                ),
                Icon(Icons.calendar_today,color: Theme.of(context).iconTheme.color,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}