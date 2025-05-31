# BioSentinel – Smart Attendance Monitoring System

BioSentinel is an intelligent attendance monitoring system built for educational institutions. It combines biometric authentication (face and fingerprint recognition), Bluetooth beacon-based location tracking, and a centralized dashboard to ensure secure and reliable attendance recording for students and teachers.

## 🚀 Features

### 🔐 Authentication
- Login/Signup using Firebase
- Role-based access: Student, Teacher, Admin

### 👨‍🎓 Student Module
- Mark attendance using face/fingerprint
- Real-time Bluetooth scanning to verify presence near teacher's beacon
- View attendance records and session history

### 👩‍🏫 Teacher Module
- Create and manage courses
- Generate class sessions
- Monitor and update student attendance
- Act as a Bluetooth beacon for student scanning

### 🧑‍💼 Admin Dashboard (Web)
- Manage students, teachers, rooms, and courses
- View and export attendance reports
- Track active sessions and system usage

## 🧠 Tech Stack

- **Frontend (Mobile & Web):** Flutter
- **Backend:** Node.js, Express.js
- **Database:** MySQL
- **Authentication:** Firebase Auth
- **Bluetooth Integration:** `flutter_beacon` package
- **Biometrics:** Face recognition, Fingerprint sensor

