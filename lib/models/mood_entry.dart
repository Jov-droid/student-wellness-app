import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String mood;

  @HiveField(2)
  final int rating;

  MoodEntry(this.date, this.mood, this.rating);
}