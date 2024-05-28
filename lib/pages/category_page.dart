import 'package:flutter/material.dart';
import '../model/categories.dart';
import '../infrastructure/db/categories.dart';

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
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : categories.isEmpty
            ? const Text('No categories')
            : buildCard(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/category/add');
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
        margin: const EdgeInsets.all(8.0),
        elevation: 4.0,
        child: ListTile(
          title: Text(category.title ?? 'No title'),
          subtitle: Text(category.iconTitle ?? 'No icon'),
        ),
      );
    },
  );
}
