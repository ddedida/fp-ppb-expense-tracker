import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/components/pie_chart.dart';
import 'package:fp_ppb_expense_tracker/pages/expense_add_page.dart';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: PieChartWidget(),
      ),
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

  Widget buildCard() {
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return ListView.builder(
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${expensesByDate.fold(0.00, (prev, e) => prev + e.amount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
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
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ExpenseAddPage(expense: expense),
                        ),
                      );

                      await refreshExpenses();
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
}
