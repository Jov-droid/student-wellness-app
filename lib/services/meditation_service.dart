class MeditationService {
  static List<Map<String, dynamic>> getMeditations() {
    return [
      {
        'title': 'Deep Breathing',
        'duration': '5 min',
        'description': 'Guided breathing exercise to reduce stress',
      },
      {
        'title': 'Body Scan',
        'duration': '10 min',
        'description': 'Progressive body relaxation technique',
      },
      {
        'title': 'Mindfulness',
        'duration': '15 min',
        'description': 'Present moment awareness practice',
      },
    ];
  }
}