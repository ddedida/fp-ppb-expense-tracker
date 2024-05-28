import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';

class CategoryAddPage extends StatefulWidget {
  final Category? category;
  const CategoryAddPage({super.key, this.category});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {

  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _iconTitle;

  @override
  void initState() {
    super.initState();
    if (widget.category == null) {
      _title = '';
      _iconTitle = 'add';
    } else {
      _title = widget.category!.title!;
      _iconTitle = widget.category!.iconTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _iconTitle,
                decoration: const InputDecoration(labelText: 'Icon Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter icon title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _iconTitle = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  addOrUpdateCategory();
                },
                child: Text(widget.category == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future addCategory() async {
    final category = Category(
      title: _title,
      iconTitle: _iconTitle,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    await CategoriesDatabases.instance.create(category);
  }

  Future updateCategory() async {
    final category = widget.category!.copy(
      title: _title,
      iconTitle: _iconTitle,
      updatedAt: DateTime.now().toString(),
    );

    await CategoriesDatabases.instance.update(category);
  }

  void addOrUpdateCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.category == null) {
        await addCategory();
      } else {
        await updateCategory();
      }
      Navigator.of(context).pop();
    }
  }
}
