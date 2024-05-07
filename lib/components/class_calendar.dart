import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassCalendar extends StatefulWidget {
  @override
  _ClassCalendarState createState() => _ClassCalendarState();
}

class _ClassCalendarState extends State<ClassCalendar> {
  DateTime today = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; // Added state variable

  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState((){
      today = day;
    });
  }

  // Callback function to handle format changes
  void _onFormatChanged(CalendarFormat newFormat) {
    setState(() {
      _calendarFormat = newFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true, // Show the format button
        formatButtonDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: false,
      ),
      availableGestures: AvailableGestures.all,
      selectedDayPredicate: (day) => isSameDay(
        day, today),
      focusedDay: today,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2999, 12, 31),
      onFormatChanged: _onFormatChanged, // Pass the callback function
      calendarFormat: _calendarFormat, // Pass the current format
      onDaySelected: _onDaySelected,
    );
  }
}
