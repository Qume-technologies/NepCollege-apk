# 🎓 Bridgewater College App (`college-apk`)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=Dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-blue.svg?style=for-the-badge)](https://riverpod.dev)
[![Supabase](https://img.shields.io/badge/Supabase-2.12.2-green.svg?style=for-the-badge&logo=Supabase&logoColor=white)](https://supabase.com)
[![Material 3](https://img.shields.io/badge/Material_3-Enabled-purple.svg?style=for-the-badge)](https://m3.material.io)

An offline-first, feature-rich Flutter student portal application developed for **Bridgewater International College (BWIC)**. Built with modern **Feature-First Architecture**, **Flutter Riverpod** state management, **Supabase** backend integration, and **Mistral AI** assistant support.

---

## ✨ Features

### 🔐 1. Authentication & Multi-Layer Security
* **Flexible Login**: Sign in using **Student ID** or **Email Address**.
* **Biometric Lock (`BiometricGateScreen`)**: Local fingerprint/face authentication using `local_auth` protecting app startup & background resume.
* **Password Management**: Change password with current credential validation against Supabase.
* **Multi-Factor Security**: Two-Factor Authentication (2FA) settings with Email OTP toggle.
* **Contact Updates**: Verification-gated contact editor with email formatting checks.

### 📊 2. Academic & Campus Modules
* **Dashboard (`DashboardScreen`)**: Real-time greetings based on Nepal Standard Time (NST), pull-to-refresh sync, quick action shortcuts, attendance board, timetable preview, assignments summary, GPA cards, and latest notices.
* **Attendance Tracker (`AttendanceScreen`)**: Overall percentage gauge, lecture statistics, and month-by-month progress reports.
* **Academic Timetable (`TimetableScreen`)**: Day-wise timetable filtering based on student department, admission year, and room number.
* **Assignments (`AssignmentsScreen`)**: Task list with due date formatting and description popups.
* **Exams & Results (`ExamScreen`, `ResultsScreen`)**: Upcoming exam schedules, semester GPA breakdown, result document previews, and relative class rank calculation (`getExamRank`).
* **Fee Management (`FeesScreen`)**: Remaining outstanding counter, payment transaction history, and support section.
* **Leave Applications (`LeaveNoteScreen`)**: Apply for leave with date range selection and admin reply tracking.
  * 📴 **Offline Sync Queue**: Submissions made offline are saved locally in `SharedPreferences` and automatically synced to Supabase when network connectivity returns.
* **Departmental Notices (`NoticesScreen`)**: Scoped notice board filtered by student department and room number.

### 🤖 3. Academic AI Support & Help Center
* **Academic AI Assistant (`LiveChatPage`)**: Integrated AI chat powered by **Mistral AI (`open-mistral-7b`)** customized with BWIC academic knowledge.
* **IT Ticket Dispatch**: Issue technical support tickets directly to the IT helpdesk.
* **FAQ & Support (`FAQPage`)**: Expandable FAQ tiles addressing common student queries.

---

## 🏗️ Architecture & Project Structure

The codebase strictly adheres to **Feature-First Architecture** and **Clean Code** principles. Global infrastructure resides in `lib/core/`, while individual features are encapsulated in `lib/features/<feature_name>/`.

```text
lib/
├── core/                        <-- Global Utilities & Shared Infrastructure
│   ├── config/                  <-- AppConfig & Dotenv configuration
│   ├── providers/               <-- Global Riverpod Service & Theme providers
│   ├── screens/                 <-- App-level screens (SplashScreen)
│   ├── services/                <-- Data services (AcademicService, ProfileService)
│   ├── theme/                   <-- Material 3 AppTheme & ThemeManager
│   └── widgets/                 <-- Shared widgets (AuthHeader, CustomTextField, PrimaryButton)
├── features/                    <-- Domain Features
│   ├── assignments/             <-- screens/, widgets/, providers/
│   ├── attendance/              <-- screens/, widgets/, providers/
│   ├── auth/                    <-- screens/, widgets/, providers/
│   ├── dashboard/               <-- screens/, widgets/, providers/
│   ├── exams/                   <-- screens/, widgets/, providers/
│   ├── fees/                    <-- screens/, widgets/, providers/
│   ├── help/                    <-- screens/, widgets/, providers/
│   ├── home/                    <-- screens/, widgets/, providers/
│   ├── leave/                   <-- screens/, widgets/, providers/
│   ├── legal/                   <-- screens/, widgets/, providers/
│   ├── map/                     <-- screens/, widgets/, providers/
│   ├── notices/                 <-- screens/, widgets/, providers/
│   ├── profile/                 <-- screens/, widgets/, providers/
│   ├── results/                 <-- screens/, widgets/, providers/
│   ├── security/                <-- screens/, widgets/, providers/
│   └── timetable/               <-- screens/, widgets/, providers/
└── main.dart                    <-- App Entrypoint (ProviderScope & Dotenv load)
```

---

## ⚡ State Management (Riverpod)

The app utilizes **Flutter Riverpod (2.6.1)** for reactive state management:
* **`ProviderScope`**: Wraps the root `MaterialApp` in `main.dart`.
* **Feature Notifiers (`StateNotifierProvider`)**: Manage asynchronous UI states (`AsyncValue<T>`) for fetching, caching, and submitting data (e.g. `authProvider`, `dashboardProvider`, `leaveProvider`, `attendanceProvider`).
* **Service Injection (`Provider`)**: Exposes `AcademicService` and `ProfileService` to feature notifiers for clean dependency injection and testability.

---

## 🗄️ Database Setup (`query.sql`)

The repository includes a complete SQL schema file (`query.sql`) located in the root directory. Execute `query.sql` in the **Supabase SQL Editor** to automatically generate all 10 required database tables, indexes, RLS policies, and sample seed data:

* **Tables**: `profiles`, `attendance`, `timetable`, `assignments`, `notices`, `notifications`, `fees`, `exams`, `results`, `leave_notes`.
* **Indexes**: Configured on foreign keys, `student_id`, `department`, `due_date`, and `created_at` for optimal query speed.
* **Row-Level Security (RLS)**: Public read/write policies configured for direct table queries.

---

## ⚙️ Environment Configuration (`.env`)

Environment variables are loaded dynamically at runtime via `flutter_dotenv`.

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Fill in your Supabase and Mistral AI credentials in `.env`:
   ```env
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key-here
   MISTRAL_API_URL=https://api.mistral.ai/v1/chat/completions
   MISTRAL_API_KEY=your-mistral-api-key-here
   COLLEGE_WEBSITE=https://bridgewater.edu.np
   ```

> 🔒 **Security Note**: `.env` is listed in `.gitignore` to prevent sensitive credentials from being committed to version control.

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.11.4` or higher)
* [Dart SDK](https://dart.dev/get-started)
* Android Studio / VS Code with Flutter extension

### Installation & Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/iamglitch404/college-apk.git
   cd college-apk
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Environment File**:
   Ensure `.env` exists in the root directory as shown above.

4. **Run Static Analysis Check**:
   ```bash
   flutter analyze
   ```

5. **Launch the Application**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

Run automated widget and unit tests:
```bash
flutter test
```

---

## 📜 License & Copyright
Developed for **Bridgewater International College (BWIC)**. All rights reserved.
