import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/widgets/budget_form_widget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late List<Category> categories;
  bool isLoading = false;

  Future refreshData() async {
    setState(() => isLoading = true);

    categories = await CategoriesDatabases.instance.readAllCategories();

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    CategoriesDatabases.instance.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void showAlertDialog(BuildContext context, Category category) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => BudgetFormWidget(
            date: '2024-05-25', categoryId: category.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : categories.isEmpty
              ? const Text('No Categories')
              : Column(
                  children: <Widget>[
                    const Text('Limits'),
                    Expanded(child: buildCard()),
                  ],
                ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(category.title ?? 'No title'),
              subtitle: Text(category.iconTitle ?? 'No icon'),
              trailing: ElevatedButton(
                onPressed: () => showAlertDialog(context, category),
                child: const Text('Set Limit'),
              ),
            ),
          );
        },
      );
}
