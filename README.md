# Student Wellness App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A *mental wellness mobile application* for students designed to support emotional health, self-reflection, relaxation, and connection with peers — built using **Flutter** with a modern, responsive UI. 

## 📱 App Overview
The Student Wellness App helps students improve and track their mental health through the following core features:
- 🎭 **Mood Tracking** — Daily mood inputs with visual history and trends.  
- ✍️ **Private Journaling** — Secure text entries encrypted on the device.  
- 🧘 **Guided Meditation** — Audio-based relaxation sessions.  
- 💬 **Peer Support Chat** — Anonymous space to connect with peers.  
- 🚨 **Emergency Resources** — Quick access to emergency contacts.  
- 🌗 **Light/Dark Theme Support** — User preference toggle.  
- ✨ **Smooth Animations & UX Transitions** — Engagement-focused design.
  
## 🧩 Architecture

This app uses **Flutter**, which allows building *cross-platform mobile apps* (Android ) from a single codebase. 

### 🛠️ Technical Stack

| Component | Technology |
|-----------|------------|
| UI Framework | **Flutter (Dart)** |
| State Management | **Provider** |
| Local Database | **Hive** (fast key/value DB) |
| Secure Local Storage | **flutter_secure_storage** |
| Animations | **Lottie** |
| Audio Playback | **just_audio** |
| Platforms | Android | 



## 🧠 Feature Breakdown

### 📊 Mood Tracker

- Students select emotions or mood states (e.g., 😃 happy, 😔 sad).  
- Mood history is stored locally and presented in charts or timelines.  
- Helps users spot patterns over time.  
- Optimized with Hive for offline performance. 



### 📝 Private Journal

- Users can create journal entries — text, optionally with timestamps.  
- Entries are stored securely and **encrypted** using `flutter_secure_storage`.  
- Only the device can read the stored data — no cloud upload by default.  
- Promotes reflective writing as a wellness habit. 



### 🧘 Guided Meditation

- Pre-loaded meditation sessions (audio or animation-enhanced).  
- Uses **just_audio** for sound playback control (play/pause/stop).  
- Lottie animations enhance visual experience.  
- Designed for relaxation and anxiety reduction. 



### 💬 Peer Support Chat

- A real-time chat interface for students to support one another.  
- May use local sockets/backend or third-party chat service (details in code).  
- Encourages community and shared experiences.  
- Privacy and moderation are important considerations. 



### 🚨 Emergency Contacts

- Fast access screen with customizable emergency numbers.  
- Intended for moments when students need immediate help.  
- Contacts can be called directly from the app interface. 



## 🧠 How It Works

1. **Install and launch** the app.  
2. On first run, initialize local storage.  
3. Track mood each day using the Mood Tracker.  
4. Add journal entries any time for reflection.  
5. Use guided meditation to relax.  
6. Chat with peers for support and connection.  
7. Access emergency contacts quickly when needed. 


  
## Screenshots

<img width="207" height="388" alt="white_theme" src="https://github.com/user-attachments/assets/f084c446-53bc-43ca-96da-8f817f459068" />
<img width="218" height="390" alt="dark_theme" src="https://github.com/user-attachments/assets/ef12e51f-724e-419d-8c03-4ca1a1477404" />



<img width="417" height="442" alt="mood_tracker" src="https://github.com/user-attachments/assets/17b02917-5839-4a47-b956-8aa3d9e32f81" />


<img width="207" height="384" alt="light_meditation" src="https://github.com/user-attachments/assets/7762bc06-2f07-44a5-8792-7bb1903ff3f7" />
<img width="188" height="387" alt="dark_Meditation" src="https://github.com/user-attachments/assets/82a92d02-ae1b-4a0d-b57b-2aaa25d22b97" />


<img width="205" height="393" alt="journal" src="https://github.com/user-attachments/assets/fecbd191-1667-4a48-badb-cbeef5eec5f4" />


<img width="225" height="382" alt="emergency" src="https://github.com/user-attachments/assets/85048371-8247-486c-8a2f-b6af84952823" />


## ⚙️ Installation


### Prerequisites
- Flutter SDK (v3.8.1 or higher)
- Android Studio 
- Android device/emulator (API 21+)

### Steps
1. Clone the repository:
```bash
git clone https://github.com/Jov-droid/student-wellness-app.git
```

# 2. Change directory
cd student-wellness-app

# 3. Get dependencies
flutter pub get

# 4. Run on device/emulator
flutter run

### APK Installation
1. Go to the [Releases](https://github.com/Jov-droid/student-wellness-app/releases) section of this repository
2. Download the latest APK file from the assets (e.g. `app-release.apk`)
3. Install the APK on your Android device

## 📁 Project Structure

```text
├── android/                # Android native project
├── ios/                    # iOS native project
├── lib/                    # Main Flutter source code
│   ├── models/             # App data models
│   ├── providers/          # State management (Provider)
│   ├── screens/            # UI Screens
│   ├── services/           # Business logic & data services
│   ├── utils/              # Utility classes & helpers
│   └── main.dart           # Application entry point
├── assets/                 # Media assets (images, audio, animations)
├── screenshots/            # UI screenshots for documentation
├── test/                   # Unit and widget tests
└── pubspec.yaml            # Dependencies & metadata



The lib/ folder houses most of the app logic: screens, UI widgets, local data handling, audio, and theming.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
