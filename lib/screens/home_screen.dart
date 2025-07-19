import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_wellness/screens/emergency_contacts.dart';
import 'package:student_wellness/screens/journal_screen.dart';
import 'package:student_wellness/screens/meditation_screen.dart';
import 'package:student_wellness/screens/mood_tracker.dart';
import 'package:student_wellness/screens/peer_chat.dart';
import 'package:student_wellness/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Screens for each navigation item
  final List<Widget> _screens = const [
    MoodTrackerScreen(),
    JournalScreen(),
    PeerChatScreen(),
    MeditationScreen(),
    EmergencyContactsScreen(),
  ];

  // Titles for each screen
  final List<String> _screenTitles = const [
    'Mood Tracker',
    'Journal',
    'Peer Support',
    'Meditation',
    'Emergency Contacts',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Configure fade animation
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Configure scale animation
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Clean up animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _screenTitles[_currentIndex],
            key: ValueKey<int>(_currentIndex),
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        actions: [
          // Animated settings button
          ScaleTransition(
            scale: _scaleAnimation,
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const SettingsScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimation,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            // Restart animation when tab changes
            _animationController.reset();
            _animationController.forward();
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          items: [
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/mood.json',
                width: 30,
                height: 30,
                animate: _currentIndex == 0,
              ),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/journal.json',
                width: 30,
                height: 30,
                animate: _currentIndex == 1,
              ),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/chat.json',
                width: 30,
                height: 30,
                animate: _currentIndex == 2,
              ),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/meditation.json',
                width: 30,
                height: 30,
                animate: _currentIndex == 3,
              ),
              label: 'Meditation',
            ),
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/emergency.json',
                width: 30,
                height: 30,
                animate: _currentIndex == 4,
              ),
              label: 'Emergency',
            ),
          ],
        ),
      ),
    );
  }
}