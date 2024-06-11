import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/services/api.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';

class ServerDevelopmentButtonGroup extends StatefulWidget {
  const ServerDevelopmentButtonGroup({
    super.key,
  });

  @override
  State<ServerDevelopmentButtonGroup> createState() =>
      _ServerDevelopmentButtonGroupState();
}

class _ServerDevelopmentButtonGroupState
    extends State<ServerDevelopmentButtonGroup> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              final data = await ApiService().getExpensesInCloud();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data fetched from cloud'),
                ),
              );

              for (var element in data) {
                final expense = Expense(
                  id: element['expense_id'],
                  title: element['title'],
                  amount: (element['amount'] as int).toDouble(),
                  date: DateTime.parse(element['date']),
                  typeId: element['type_id'],
                  categoryId: element['category_id'],
                  createdAt: DateTime.parse(element['CreatedAt']),
                  updatedAt: DateTime.parse(element['UpdatedAt']),
                );

                ExpensesDatabases.instance.create(expense);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data stored to db'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${e}"),
                ),
              );
            }
          },
          child: const Text('Fetch Backup and store to db'),
        ),
        ElevatedButton(
          onPressed: () async {
            final expense = await ExpensesDatabases.instance.readAllExpenses();

            await ApiService().addExpenseToCloud(expense);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data backed up to cloud'),
              ),
            );
          },
          child: const Text('Backup'),
        ),
      ],
    );
  }
}
