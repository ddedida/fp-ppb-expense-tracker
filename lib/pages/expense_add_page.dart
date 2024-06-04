import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';

class ExpenseAddPage extends StatefulWidget {
  final Expense? expense;

  const ExpenseAddPage({super.key, this.expense});

  @override
  State<ExpenseAddPage> createState() => _ExpenseAddPageState();
}

class _ExpenseAddPageState extends State<ExpenseAddPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _date;
  late int _typeId;
  late String _categoryId;

  @override
  void initState() {
    super.initState();
    if (widget.expense == null) {
      _title = '';
      _amount = 0.0;
      _date = DateTime.now();
      _typeId = 0;
      _categoryId = '';
    } else {
      _title = widget.expense!.title!;
      _amount = widget.expense!.amount;
      _date = widget.expense!.date;
      _typeId = widget.expense!.typeId;
      _categoryId = widget.expense!.categoryId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              const SizedBox(height: 16),
              InputDatePickerFormField(
                initialDate: _date,
                firstDate: DateTime(1999),
                lastDate: DateTime.now(),
                onDateSaved: (value) {
                  _date = value;
                },
              ),
              TextFormField(
                initialValue: _typeId.toString(),
                decoration: const InputDecoration(labelText: 'Type ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter type ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _typeId = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: 'Category ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _categoryId = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addOrUpdateExpense();
                },
                child: Text(widget.expense == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addExpense() async {
    final expense = Expense(
      title: _title,
      amount: _amount,
      date: _date,
      typeId: _typeId,
      categoryId: _categoryId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ExpensesDatabases.instance.create(expense);
  }

  Future updateExpense() async {
    final expense = widget.expense!.copy(
      title: _title,
      amount: _amount,
      date: _date,
      typeId: _typeId,
      categoryId: _categoryId,
      updatedAt: DateTime.now(),
    );

    await ExpensesDatabases.instance.update(expense);
  }

  void addOrUpdateExpense() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.expense == null) {
        await addExpense();
      } else {
        await updateExpense();
      }
      Navigator.of(context).pop();
    }
  }
}
