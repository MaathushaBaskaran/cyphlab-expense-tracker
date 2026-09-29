import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _selectedDate;
  late String _selectedCategory;
  bool _isSaving = false;

  final List<String> _categories = [
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
    'Shopping',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense?.title ?? '');
    _amountController = TextEditingController(
      text: widget.expense != null ? widget.expense!.amount.toStringAsFixed(2) : '',
    );
    _selectedDate = widget.expense?.date ?? DateTime.now();
    _selectedCategory = widget.expense?.category ?? _categories.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text.trim());

    if (widget.expense == null) {
      await provider.addExpense(title, amount, _selectedDate, _selectedCategory);
    } else {
      await provider.updateExpense(
        widget.expense!.id,
        title,
        amount,
        _selectedDate,
        _selectedCategory,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (val) =>
                          (val == null || val.trim().isEmpty) ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Please enter an amount';
                        final parsed = double.tryParse(val);
                        if (parsed == null || parsed <= 0) return 'Enter a valid positive number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      leading: const Icon(Icons.calendar_today),
                      title: Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                      trailing: TextButton(
                        onPressed: _pickDate,
                        child: const Text('Change'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _saveForm,
                      child: Text(
                        isEditing ? 'Update Expense' : 'Save Expense',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}