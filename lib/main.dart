import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:student_wellness/models/journal_entry.dart';
import 'package:student_wellness/models/mood_entry.dart';
import 'package:student_wellness/providers/theme_provider.dart'; // Added theme provider
import 'package:student_wellness/screens/home_screen.dart';
import 'package:student_wellness/services/hive_service.dart';
import 'package:student_wellness/themes/app_themes.dart'; // Added theme definitions

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(JournalEntryAdapter());

  // Verify audio assets
  print("🔊 Audio Asset Verification");
  try {
    final manifest = await rootBundle.loadString('AssetManifest.json');

    final audioFiles = [
      'assets/audios/breathing.mp3',
      'assets/audios/body_scan.mp3',
      'assets/audios/mindfulness.mp3',
    ];

    for (final file in audioFiles) {
      if (manifest.contains('"$file"')) {
        print("✅ Found: $file");
      } else {
        print("❌ Missing: $file");
      }
    }
  } catch (e) {
    print("🔴 Error checking assets: $e");
  }

  // Open Hive boxes
  await HiveService.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const StudentWellnessApp(),
    ),
  );
}

class StudentWellnessApp extends StatelessWidget {
  const StudentWellnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Student Wellness',
      theme: AppThemes.lightTheme, // Use light theme
      darkTheme: AppThemes.darkTheme, // Use dark theme
      themeMode: themeProvider.themeMode, // Use theme mode from provider
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}