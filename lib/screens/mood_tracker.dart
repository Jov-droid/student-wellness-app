import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_wellness/models/mood_entry.dart';
import 'package:student_wellness/services/hive_service.dart';
import 'package:student_wellness/widgets/mood_calendar.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key}); // Add const constructor

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final List<String> moods = ['😭', '😔', '😐', '🙂', '😄'];
  String? _selectedMood;
  int? _selectedRating;
  DateTime _selectedDate = DateTime.now();

  void _logMood() {
    if (_selectedMood != null && _selectedRating != null) {
      HiveService.addMoodEntry(
        MoodEntry(_selectedDate, _selectedMood!, _selectedRating!),
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood logged successfully')),
        );
        setState(() {
          _selectedMood = null;
          _selectedRating = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mood Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Mood selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: moods.asMap().entries.map((entry) {
                return ChoiceChip(
                  label: Text(entry.value, style: const TextStyle(fontSize: 24)),
                  selected: _selectedRating == entry.key,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRating = selected ? entry.key : null;
                      _selectedMood = selected ? entry.value : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Select Date'),
              subtitle: Text(DateFormat.yMMMd().format(_selectedDate)),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logMood,
              child: const Text('Log Mood'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 40),
            const Text('Your Mood History', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const MoodCalendarWidget(),
          ],
        ),
      ),
    );
  }
}