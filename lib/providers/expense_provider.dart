import 'dart:async';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<Expense>>? _subscription;

  List<Expense> _expenses = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';

  List<Expense> get expenses {
    if (_selectedCategory == 'All') {
      return _expenses;
    }
    return _expenses.where((e) => e.category == _selectedCategory).toList();
  }

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  double get monthlyTotal {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  ExpenseProvider() {
    _initExpenses();
  }

  void _initExpenses() {
    _subscription = _firestoreService.getExpenses().listen((expenseList) {
      _expenses = expenseList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addExpense(String title, double amount, DateTime date, String category) async {
    final newExpense = Expense(
      id: '',
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    await _firestoreService.addExpense(newExpense);
  }

  Future<void> updateExpense(String id, String title, double amount, DateTime date, String category) async {
    final updated = Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    await _firestoreService.updateExpense(updated);
  }

  Future<void> deleteExpense(String id) async {
    await _firestoreService.deleteExpense(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}