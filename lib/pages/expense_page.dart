import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future refreshExpenses() async {
    setState(() => isLoading = true);

    expenses = await ExpensesDatabases.instance.readAllExpenses();

    setState(() => isLoading = false);
  }

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
          Navigator.pushNamed(context, '/expense/add')
              .then((_) => refreshExpenses());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          final date = expense.date;
          final formattedDate = DateFormat.yMMMd().format(date);
          final expensesByDate = expenses.where((e) => e.date == date).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0 || date != expenses[index - 1].date)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ListTile(
                subtitle: Text(expense.title ?? ""),
                title: Text('\$${expense.amount.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(
                          '/expense/add',
                          arguments: expense,
                        );

                        refreshExpenses();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ExpensesDatabases.instance.delete(expense.id!);
                        refreshExpenses();
                      },
                    ),
                  ],
                ),
              ),
              if (index == expenses.length - 1 ||
                  date != expenses[index + 1].date)
                const Divider(),
            ],
          );
        },
      );
}
