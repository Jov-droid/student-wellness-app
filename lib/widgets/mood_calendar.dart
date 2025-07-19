import 'package:flutter/material.dart';
import 'package:student_wellness/models/mood_entry.dart';
import 'package:student_wellness/services/hive_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MoodCalendarWidget extends StatefulWidget {
  const MoodCalendarWidget({super.key});

  @override
  State<MoodCalendarWidget> createState() => _MoodCalendarWidgetState();
}

class _MoodCalendarWidgetState extends State<MoodCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, MoodEntry> _moodEntries = {};

  @override
  void initState() {
    super.initState();
    _loadMoodEntries();
  }

  void _loadMoodEntries() {
    final entries = HiveService.getMoodEntries();
    for (var entry in entries) {
      // Normalize date to remove time part
      final date = DateTime(entry.date.year, entry.date.month, entry.date.day);
      _moodEntries[date] = entry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime(2020),
          lastDay: DateTime.now(),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final entry = _moodEntries[date];
              if (entry != null) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      entry.mood,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
        if (_selectedDay != null && _moodEntries.containsKey(_selectedDay))
          _buildMoodDetail(_moodEntries[_selectedDay]!),
      ],
    );
  }

  Widget _buildMoodDetail(MoodEntry entry) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Mood on ${DateFormat.yMMMd().format(entry.date)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Feeling: ${entry.mood}', style: const TextStyle(fontSize: 16)),
          Text('Rating: ${entry.rating}/5', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}