import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_edit_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final categories = ['All', 'Food', 'Transport', 'Entertainment', 'Bills', 'Shopping', 'Other'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Colors.blueAccent],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Spending Total',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  NumberFormat.currency(symbol: '\$').format(expenseProvider.monthlyTotal),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: categories.map((cat) {
                final isSelected = expenseProvider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => expenseProvider.filterByCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: expenseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : expenseProvider.expenses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'No expenses found',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: expenseProvider.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenseProvider.expenses[index];
                          return Dismissible(
                            key: Key(expense.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (_) async {
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Expense'),
                                  content: const Text('Are you sure you want to delete this expense?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (_) {
                              expenseProvider.deleteExpense(expense.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Expense deleted')),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(expense.category[0]),
                                ),
                                title: Text(
                                  expense.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '${expense.category} • ${DateFormat.yMMMd().format(expense.date)}',
                                ),
                                trailing: Text(
                                  '\$${expense.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddEditExpenseScreen(expense: expense),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}