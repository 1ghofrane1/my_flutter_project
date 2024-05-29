import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassCalendar extends StatefulWidget {
  const ClassCalendar({super.key});

  @override
  _ClassCalendarState createState() => _ClassCalendarState();
}

class _ClassCalendarState extends State<ClassCalendar> {
  DateTime today = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month; // Added state variable

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
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
    return Card(
      elevation: 4, // Adjust elevation for shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Soft edges
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: true, // Show the format button
            formatButtonDecoration: BoxDecoration(
              color: const Color.fromARGB(207, 190, 242, 100),
              borderRadius: BorderRadius.circular(10.0),
            ),
            formatButtonTextStyle: const TextStyle(
              color: Color(0xFF171717),
              fontWeight: FontWeight.bold,
            ),
            formatButtonShowsNext: false,
          ),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          focusedDay: today,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2999, 12, 31),
          onFormatChanged: _onFormatChanged, // Pass the callback function
          calendarFormat: _calendarFormat, // Pass the current format
          onDaySelected: _onDaySelected,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: const Color.fromARGB(255, 190, 242, 100).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: const Color(0xFFBEF264).withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(color: Color(0xFF171717)),
            outsideTextStyle: const TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
