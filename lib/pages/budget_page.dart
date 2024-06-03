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

  IconData _getIconDataFromTitle(String iconTitle) {
    switch (iconTitle) {
      case 'Icons.home':
        return Icons.home;
      case 'Icons.sports_soccer':
        return Icons.sports_soccer;
      case 'Icons.fastfood':
        return Icons.fastfood;
      case 'Icons.videogame_asset':
        return Icons.videogame_asset;
      case 'Icons.stacked_line_chart':
        return Icons.stacked_line_chart;
      case 'Icons.sports_motorsports':
        return Icons.sports_motorsports;
      case 'Icons.emoji_transportation':
        return Icons.emoji_transportation;
      case 'Icons.shopping_cart':
        return Icons.shopping_cart;
      case 'Icons.medication':
        return Icons.medication;
      case 'Icons.school':
        return Icons.school;
      case 'Icons.card_giftcard':
        return Icons.card_giftcard;
      case 'Icons.shield':
        return Icons.shield;
      case 'Icons.monetize_on':
        return Icons.monetization_on;
      case 'Icons.favorite':
        return Icons.favorite;
      case 'Icons.star':
        return Icons.star;
      default:
        return Icons.help; // default icon
    }
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

          IconData iconData = _getIconDataFromTitle(category.iconTitle!);

          return Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                        category.title ?? 'No title',
                        style: const TextStyle(
                          fontSize: 18.0,
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
