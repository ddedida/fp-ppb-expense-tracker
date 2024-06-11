import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/budget.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/services/api.dart';
import 'package:fp_ppb_expense_tracker/model/budget.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
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
    return Column(
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
          child: const Text('Fetch Backup Expenses'),
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
          child: const Text('Dump Expenses to Cloud'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final data = await ApiService().getCategoryInCloud();

              for (var element in data) {
                final category = Category(
                  id: element['_id'],
                  title: element['title'],
                  iconCodePoint: element['icon_code_point'],
                  categoriesType: element['categories_type'],
                  createdAt: element['created_at'],
                  updatedAt: element['updated_at'],
                );

                CategoriesDatabases.instance.create(category);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data fetched from cloud'),
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
          child: const Text('Fetch Backup Categories'),
        ),
        ElevatedButton(
          onPressed: () async {
            final category =
                await CategoriesDatabases.instance.readAllCategories();

            await ApiService().addCategoryToCloud(category);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data backed up to cloud'),
              ),
            );
          },
          child: const Text('Dump Categories to Cloud'),
        ),
        ElevatedButton(
          child: const Text('Fetch Backup Budgets'),
          onPressed: () async {
            try {
              final data = await ApiService().getBudgetInCloud();

              for (var element in data) {
                final budget = Budget(
                  id: element['_id'],
                  amount: (element['amount'] as int).toDouble(),
                  date: element['date'],
                  categoryId: element['category_id'],
                  createdAt: element['created_at'],
                  updatedAt: element['updated_at'],
                );

                BudgetDatabase.instance.create(budget);
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data fetched from cloud'),
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
        ),
        ElevatedButton(
          child: const Text('Dump Budgets to Cloud'),
          onPressed: () async {
            final budget = await BudgetDatabase.instance.readAllBudgets();

            await ApiService().addBudgetToCloud(budget);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data backed up to cloud'),
              ),
            );
          },
        ),
      ],
    );
  }
}
