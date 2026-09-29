# CyphLab Expense Tracker

A clean, responsive cross-platform expense tracker built with **Flutter**, **Provider**, and **Google Cloud Firestore**.

---

## Features Implemented

- **Full CRUD Operations**: Create, read, update, and dismiss/delete expense entries with confirmation dialogs.
- **Cloud Persistence & Real-Time Sync**: Backed by Google Cloud Firestore for continuous stream synchronization.
- **Monthly Summary Metric**: Real-time spending calculation showing current month expenditures.
- **Category Filtering**: Filter expenses instantly across categories (Food, Transport, Bills, Entertainment, Shopping, Other).
- **Interactive Form Validation**: Data verification with integrated Material date pickers.
- **Clean Architecture**: Decoupled folder structure separating Data Models, Services, State Management (Provider), and Views.

---

## Technologies & Packages Used

- **Framework**: [Flutter](https://flutter.dev/) (Dart SDK)
- **State Management**: [`provider`](https://pub.dev/packages/provider)
- **Database & Backend**: [`cloud_firestore`](https://pub.dev/packages/cloud_firestore), [`firebase_core`](https://pub.dev/packages/firebase_core)
- **Utilities & Date Formatting**: [`intl`](https://pub.dev/packages/intl)

---

## AI Tools Used & Impact

- **Google Gemini (Collaborative Development Partner)**:
  - **Architecture & Scaffolding**: Assisted in architecting a clean separation of concerns across models, service layers, and state providers.
  - **Firebase Configuration**: Streamlined Firestore stream subscription logic and data serialization methods.
  - **Debugging & Workflow**: Assisted with resolving tooling nuances across Chrome web testing and environment setup.

---

## Project Structure

```text
lib/
├── firebase_options.dart          # Auto-generated FlutterFire platform configuration
├── main.dart                      # Application root & Provider registration
├── models/
│   └── expense.dart               # Expense schema & Firestore serialization
├── providers/
│   └── expense_provider.dart      # Reactive state management & business logic
├── screens/
│   ├── home_screen.dart           # Dashboard, monthly total summary & expense feed
│   └── add_edit_expense_screen.dart # Form screen for creating & modifying entries
└── services/
    └── firestore_service.dart     # Firestore query handlers & CRUD methods

