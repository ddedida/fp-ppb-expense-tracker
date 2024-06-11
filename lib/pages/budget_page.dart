import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/components/budget_form.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/budget.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/expenses.dart';
import 'package:fp_ppb_expense_tracker/model/budget.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/model/expenses.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Category> categories;
  late List<Category> categoriesBudget;
  late List<Budget> budgets;
  late List<Expense> expenses;
  late Set<String> budgetCategoryIds;
  bool isLoading = false;
  double totalBudget = 0;
  double totalSpent = 0;
  double remaining = 0;

  Future refreshData() async {
    setState(() => isLoading = true);

    totalBudget = 0;
    totalSpent = 0;

    categories = await CategoriesDatabases.instance.readAllCategories();
    budgets = await BudgetDatabase.instance.readAllBudgets();
    expenses = await ExpensesDatabases.instance.readAllExpenses();

    if (budgets.isNotEmpty) {
      totalBudget = budgets.fold(0, (sum, budget) => sum + budget.amount);
    }

    if (expenses.isNotEmpty) {
      totalSpent = expenses.fold(0, (sum, expense) => sum + expense.amount);
    }

    remaining = totalBudget - totalSpent;

    Set<String> budgetCategoryIds = {};
    for (Budget budget in budgets) {
      budgetCategoryIds.add(budget.categoryId!);
    }

    categoriesBudget = [];
    for (Category category in categories) {
      if (budgetCategoryIds.contains(category.id.toString())) {
        categoriesBudget.add(category);
      }
    }

    for (Category category in categoriesBudget) {
      categories.remove(category);
    }

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    CategoriesDatabases.instance.close();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    refreshData();
  }

  void showAlertDialog(BuildContext context, Category category) async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => BudgetFormWidget(
        date: '2024-05-25',
        categoryId: category.id.toString(),
      ),
    );

    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : categories.isEmpty && categoriesBudget.isEmpty
              ? const Text('No categories')
              : DefaultTabController(
                  length: 2,
                  child: SafeArea(
                    child: Scaffold(
                      body: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60.0,
                            child: budgets.isEmpty
                                ? const Center(
                                    child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text('No budget set yet')
                                    ],
                                  ))
                                : Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Total Budget',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('$totalBudget'),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Total Spent',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text('$totalSpent'),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Remaining',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '$remaining',
                                              style: TextStyle(
                                                color: remaining > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            height: 50,
                            child: AppBar(
                              bottom: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(
                                    text: "Budgeted Categories",
                                  ),
                                  Tab(
                                    text: "Non Budgeted Categories",
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(
                                controller: _tabController,
                                children: <Widget>[
                                  Container(
                                      child: categoriesBudget.isEmpty
                                          ? const Center(
                                              child:
                                                  Text('No category budgets'))
                                          : buildCard(categoriesBudget)),
                                  Container(
                                      child: categories.isEmpty
                                          ? const Center(
                                              child: Text('No categories'))
                                          : buildCard(categories)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget buildCard(List<Category> categories) => ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          IconData iconData =
              IconData(category.iconCodePoint, fontFamily: 'MaterialIcons');

          return Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: ListTile(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(iconData, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () => showAlertDialog(context, category),
                  child: const Text('Set Limit'),
                ),
              ),
            ),
          );
        },
      );
}
