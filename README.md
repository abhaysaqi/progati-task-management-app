# Progati - Production-Ready Todo App

Progati is a beautiful, modern, and production-ready Todo application built with Flutter. It utilizes Clean Architecture principles to ensure scalability, testability, and a clear separation of concerns.

## ✨ Features

- **Task Management**: Create, read, update, and delete tasks easily.
- **Reminders & Notifications**: Set due dates and get local push notifications to remind you of upcoming tasks.
- **Smart Reminders**: Quick-select chips to set reminders 3h, 12h, or 1 day before a task is due, or pick a custom date/time.
- **Search & Sort**: Powerful search functionality to find tasks quickly, with options to sort by Date, Priority, or Alphabetically.
- **Theming**: Beautiful, fully custom UI with comprehensive Light and Dark modes. Theme preferences are saved locally.
- **Privacy-First**: All data is stored locally on your device using Hive. No cloud syncing, complete data sovereignty.
- **Clear All Data**: A secure option to permanently delete all local tasks and settings if desired.

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) & [equatable](https://pub.dev/packages/equatable)
- **Architecture**: Feature-First Clean Architecture (Domain / Data / Presentation layer extraction)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Local Storage**: [hive](https://pub.dev/packages/hive) & [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
- **Notifications**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) & [timezone](https://pub.dev/packages/timezone)

## 📁 Architecture Overview

The project heavily adheres to the **Clean Architecture** pattern, divided into three main layers:

1.  **Domain Layer**: The core of the application. It contains `Entities` (TaskEntity), `Repositories` (interfaces), and `UseCases` (AddTaskUseCase, GetTasksUseCase, etc.). It is completely independent of any other layer or external packages.
2.  **Data Layer**: Responsible for data retrieval and storage. It contains `Models` (Hive adapters), `DataSources` (TaskLocalDataSource), and the concrete implementations of the repository interfaces defined in the Domain layer.
3.  **Presentation Layer**: Handles the UI and State Management. It contains `Pages`, `Widgets`, `Theme` configurations, and `BLoCs` (TaskBloc, SettingsBloc) that communicate with the Domain's UseCases.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.3.0 <4.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions installed

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate into the project directory:
   ```bash
   cd todo_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the code generator (for Hive models):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the app:
   ```bash
   flutter run
   ```

## 🎨 Design & UI
Progati features a custom, playful yet professional UI. It utilizes `flutter_animate` extensively to provide smooth, delightful micro-interactions when navigating between routes, checking off tasks, or interacting with forms. Note the custom `AppTheme` which strictly defines the color palettes and interactive states.

## 📄 License
This project is proprietary.
