# CyphLab Expense Tracker

A clean, responsive cross-platform expense tracker built with **Flutter**, **Provider**, and **Google Cloud Firestore**.

---

## Features

- **Full CRUD Support**: Add, view, edit, and delete/dismiss expense entries seamlessly.
- **Real-Time Synchronization**: Backed by Cloud Firestore for continuous real-time data sync.
- **Monthly Summary Dashboard**: Aggregates and displays current month spending totals automatically.
- **Category Filtering**: Filter records across categories (Food, Transport, Bills, Entertainment, Shopping, Other).
- **Architecture**: Structured Provider pattern separating Data Models, Services, State Management, and Views.
- **Form Validation**: Clean validation rules with an integrated date picker.

---

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Database**: [Cloud Firestore](https://firebase.google.com/products/firestore) (`asia-south1`)
- **Formatting**: `intl`

### Project Layout

```text
lib/
├── firebase_options.dart          # FlutterFire configuration
├── main.dart                      # App entry & Provider setup
├── models/
│   └── expense.dart               # Expense schema & Firestore mapping
├── providers/
│   └── expense_provider.dart      # Business logic & reactive state
├── screens/
│   ├── home_screen.dart           # Dashboard & expense list
│   └── add_edit_expense_screen.dart # Form screen for add/edit
└── services/
    └── firestore_service.dart     # Firestore CRUD operations

