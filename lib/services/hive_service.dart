import 'package:hive/hive.dart';
import 'package:student_wellness/models/mood_entry.dart';
import 'package:student_wellness/models/journal_entry.dart';

class HiveService {
  static late Box<MoodEntry> moodBox;
  static late Box<JournalEntry> journalBox;

  static Future<void> init() async {
    moodBox = await Hive.openBox<MoodEntry>('moodBox');
    journalBox = await Hive.openBox<JournalEntry>('journalBox');
  }

  static Future<void> addMoodEntry(MoodEntry entry) async {
    await moodBox.add(entry);
  }

  static List<MoodEntry> getMoodEntries() {
    return moodBox.values.toList();
  }

  static Future<void> addJournalEntry(JournalEntry entry) async {
    await journalBox.put(entry.id, entry);
  }

  static List<JournalEntry> getJournalEntries() {
    return journalBox.values.toList();
  }

  static Future<void> deleteJournalEntry(String id) async {
    await journalBox.delete(id);
  }
}