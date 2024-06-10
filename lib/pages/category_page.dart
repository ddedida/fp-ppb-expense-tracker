import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/pages/category_add_page.dart';
import 'package:fp_ppb_expense_tracker/pages/category_detail_page.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              isScrollControlled: true,
              context: context,
              useSafeArea: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryAddPage(iconDataList: iconDataList),
                    ],
                  ),
                );
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
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(category.title),
              trailing: Icon(
                IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                size: 32,
              ),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategoryDetailPage(category: category),
                ));
                refreshCategories();
              },
            ),
          );
        },
      );
}
