import 'package:budgeting_app/domain/entities/category.dart';
import 'package:budgeting_app/domain/entities/expense.dart';
import 'package:budgeting_app/presentation/widgets/transaction_form/amount_field.dart';
import 'package:budgeting_app/presentation/widgets/transaction_form/notes_field.dart';
import 'package:budgeting_app/presentation/widgets/transaction_form/title_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormScreen extends StatefulWidget {
  final int budgetId;
  final List<Category> categories;
  final Expense? expense;

  const ExpenseFormScreen({
    super.key,
    this.expense,
    required this.budgetId,
    required this.categories,
  });

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _amountController = TextEditingController();
  var _expenseDate = DateTime.now();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      // TODO: maybe change expense to hold a reference to the category name?
      _categoryController.text = widget.expense!.categoryId.toString();
      _amountController.text = widget.expense!.amount.toString();
      _expenseDate = DateTime.parse(widget.expense!.date);
      _notesController.text = widget.expense!.notes ?? "";
    }
  }

  void _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(_expenseDate.year, _expenseDate.month, 1),
      lastDate: DateTime(_expenseDate.year, _expenseDate.month + 1, 1).subtract(
        Duration(days: 1),
      ),
    );

    if (selectedDate != null) {
      setState(() {
        _expenseDate = selectedDate;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final title = _titleController.text;
    final category = _categoryController.text;
    final amount = double.tryParse(_amountController.text);
    final date = DateTime.now().toString();
    final notes = _notesController.text;

    if (widget.expense == null) {
      final newExpense = Expense(
        title: title,
        categoryId: 1,
        budgetId: widget.budgetId,
        amount: amount!,
        date: date,
        notes: notes,
      );
      // TODO: add expense
    } else {
      final updatedExpense = widget.expense!
          .copy(title: title, amount: amount, date: date, notes: notes);
      // TODO: update expense
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                widget.expense == null ? 'Add Transaction' : 'Edit Transaction',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TitleField(inputController: _titleController),
              AmountField(
                inputController: _amountController,
                label: "Amount",
                enabled: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${DateFormat.yMMMd().format(_expenseDate)}',
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: _pickDate,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerLeft,
                child: DropdownMenu(
                  width: 320,
                  label: const Text("Category"),
                  dropdownMenuEntries: widget.categories.map(
                    (e) {
                      return DropdownMenuEntry(value: e.name, label: e.name);
                    },
                  ).toList(),
                  inputDecorationTheme: const InputDecorationTheme(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              NotesField(inputController: _notesController),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: Text(widget.expense == null ? "Add" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
