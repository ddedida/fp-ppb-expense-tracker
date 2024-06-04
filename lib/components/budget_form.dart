import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/budget.dart';
import 'package:fp_ppb_expense_tracker/model/budget.dart';

class BudgetFormWidget extends StatefulWidget {
  final String date;
  final String categoryId;

  const BudgetFormWidget({
    super.key,
    required this.date,
    required this.categoryId,
  });

  @override
  State<BudgetFormWidget> createState() => _BudgetFormWidgetState();
}

class _BudgetFormWidgetState extends State<BudgetFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _budgetController = TextEditingController();
  late Budget? budget;
  late double amount = 0.0;

  bool isLoading = false;

  Future getBudget() async {
    setState(() => isLoading = true);

    budget = await BudgetDatabase.instance.readBudgetByCategory(
      widget.categoryId,
    );

    if (budget == null) {
      _budgetController = TextEditingController();
    } else {
      _budgetController = TextEditingController(text: '${budget!.amount}');
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    BudgetDatabase.instance.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getBudget();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildAmount(),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Clear'),
          onPressed: () {
            deleteBudget();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            addOrUpdateBudget();
          },
        )
      ],
    );
  }

  Widget buildAmount() => TextFormField(
      controller: _budgetController,
      maxLines: 1,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        hintText: '0.0',
        hintStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a budget limit';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }

        if (double.parse(value) < 0) {
          return 'Please enter a valid number';
        }

        return null;
      });

  void addOrUpdateBudget() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = budget != null;

      if (isUpdating) {
        await updateBudget();
      } else {
        await addBudget();
      }
      Navigator.pop(context);
    }
  }

  Future updateBudget() async {
    final budget = this.budget!.copy(
          amount: double.parse(_budgetController.text),
          date: widget.date,
          categoryId: widget.categoryId,
          updatedAt: DateTime.now().toString(),
        );

    await BudgetDatabase.instance.update(budget);
  }

  Future addBudget() async {
    final budget = Budget(
      amount: double.parse(_budgetController.text),
      date: widget.date,
      categoryId: widget.categoryId,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    await BudgetDatabase.instance.create(budget);
  }

  Future deleteBudget() async {
    if (budget != null) {
      await BudgetDatabase.instance.delete(budget!.id!);
    }
    Navigator.pop(context);
  }
}
