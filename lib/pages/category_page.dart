import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/pages/category_add_page.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Category> categories;
  bool isLoading = false;

  Future refreshCategories() async {
    setState(() => isLoading = true);

    categories = await CategoriesDatabases.instance.readAllCategories();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshCategories();
  }

  @override
  void dispose() {
    CategoriesDatabases.instance.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : categories.isEmpty
                  ? const Text('No categories')
                  : buildCard(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              useSafeArea: true,
              builder: (context) {
                return const SizedBox(
                    height: 170,
                    child: CategoryAddPage(iconDataList: iconDataList));
              }).then((_) => refreshCategories());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.all(4.0),
            child: ListTile(
              title: Text(category.title),
              trailing: Icon(IconData(category.iconCodePoint,
                  fontFamily: 'MaterialIcons')),
            ),
          );
        },
      );
}
