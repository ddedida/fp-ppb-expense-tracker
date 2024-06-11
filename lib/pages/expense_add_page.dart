import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';

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
      _typeId = 1;
      _categoryId = "1";
    } else {
      final expense = widget.expense!;
      _title = expense.title!;
      _amount = expense.amount;
      _date = expense.date;
      _typeId = expense.typeId;
      _categoryId = expense.categoryId!;
    }
  }

  @override
  Widget build(BuildContext context) {
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

      ExpensesDatabases.instance.update(expense);
    }

    void addOrUpdateExpense() async {
      print(_categoryId);
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

    Widget buildCategoryDropdown() {
      return FutureBuilder<List<Category>>(
        future: CategoriesDatabases.instance.readAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            if (_categoryId == "" && categories.isNotEmpty) {
              _categoryId = categories[0].id.toString();
            }
            var pass = false;
            for (var category in categories) {
              if (_categoryId == category.id.toString()) {
                pass = true;
                break;
              }
            }
            if (!pass) {
              _categoryId = categories[0].id.toString();
            }
            return DropdownButtonFormField<String>(
              value: _categoryId,
              onChanged: (String? newValue) {
                setState(() {
                  _categoryId = newValue ?? "1";
                  print(_categoryId);
                });
              },
              items: categories.map(
                (category) {
                  return DropdownMenuItem(
                    value: category.id.toString(),
                    child: Text(
                      "${category.title} ${category.id}",
                    ),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(labelText: 'Category'),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    }

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
              buildCategoryDropdown(),
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
}
