import 'package:flutter/material.dart';
import 'package:student_wellness/widgets/meditation_player.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation & Relaxation'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MeditationPlayer(
            title: 'Deep Breathing',
            duration: '5:48 min',
            audioAsset: 'assets/audios/breathing.mp3',
          ),
          const SizedBox(height: 16),
          MeditationPlayer(
            title: 'Body Scan',
            duration: '6:10 min',
            audioAsset: 'assets/audios/body_scan.mp3',
          ),
          const SizedBox(height: 16),
          MeditationPlayer(
            title: 'Mindfulness',
            duration: '7:35 min',
            audioAsset: 'assets/audios/mindfulness.mp3',
          ),
        ],
      ),
    );
  }
}