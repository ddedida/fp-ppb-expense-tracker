import 'package:flutter/material.dart';
import '../model/expenses.dart';
import '../infrastructure/db/expenses.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late List<Expense> expenses;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshExpenses();
  }

  @override
  void dispose() {
    ExpensesDatabases.instance.close();
    super.dispose();
  }

  Future refreshExpenses() async {
    setState(() => isLoading = true);

    expenses = await ExpensesDatabases.instance.readAllExpenses();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : expenses.isEmpty
                ? const Text('No expenses')
                : buildCard(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/expense/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(expense.title ?? 'No title'),
              subtitle: Text(expense.amount.toString()),
              trailing: Text(expense.date),
            ),
          );
        },
      );
}
