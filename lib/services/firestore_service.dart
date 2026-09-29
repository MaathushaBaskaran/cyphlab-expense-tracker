import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  final CollectionReference _expensesRef =
      FirebaseFirestore.instance.collection('expenses');

  Stream<List<Expense>> getExpenses() {
    return _expensesRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  Future<void> addExpense(Expense expense) async {
    await _expensesRef.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    await _expensesRef.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _expensesRef.doc(id).delete();
  }
}