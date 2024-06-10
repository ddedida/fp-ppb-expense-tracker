import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';
import 'package:fp_ppb_expense_tracker/pages/category_add_page.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';

class CategoryDetailPage extends StatefulWidget {
  final Category? category;
  const CategoryDetailPage({super.key, this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late String _title;
  late int _iconCodePoint;
  late List<Expense> expensesCategory;
  bool isLoading = false;

  Future refreshListOfExpenses() async {
    setState(() => isLoading = true);

    expensesCategory = await ExpensesDatabases.instance
        .readAllExpensesByCategory(widget.category!.id!.toString());

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _title = widget.category!.title;
    _iconCodePoint = widget.category!.iconCodePoint;
    refreshListOfExpenses();
  }

  @override
  void dispose() {
    ExpensesDatabases.instance.close();
    CategoriesDatabases.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconData(_iconCodePoint, fontFamily: 'MaterialIcons')),
            // Text(_iconCodePoint.toString()), Buat Cek value iconCodePoint
            const SizedBox(width: 16),
            Text(
              _title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () async {
              await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryAddPage(
                            iconDataList: iconDataList,
                            category: widget.category,
                          )
                        ],
                      ),
                    );
                  });
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            onPressed: () async {
              await CategoriesDatabases.instance.delete(widget.category!.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : expensesCategory.isEmpty
                  ? const Text('No expense of this category')
                  : buildCard(),
        ),
      ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: expensesCategory.length,
        itemBuilder: (context, index) {
          final expense = expensesCategory[index];
          final date = expense.date;
          final formattedDate = DateFormat.yMMMd().format(date);
          // final expensesByDate = expensesCategory.where((e) => e.date == date).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0 || date != expensesCategory[index - 1].date)
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

                        refreshListOfExpenses();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ExpensesDatabases.instance.delete(expense.id!);
                        refreshListOfExpenses();
                      },
                    ),
                  ],
                ),
              ),
              if (index == expensesCategory.length - 1 ||
                  date != expensesCategory[index + 1].date)
                const Divider(),
            ],
          );
        },
      );
}
