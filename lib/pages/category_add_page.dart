import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';

class CategoryAddPage extends StatefulWidget {
  final Category? category;
  final List<IconData> iconDataList;
  const CategoryAddPage({super.key, this.category, required this.iconDataList});

  @override
  State<CategoryAddPage> createState() => _CategoryAddPageState();
}

class _CategoryAddPageState extends State<CategoryAddPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late int _iconCodePoint;

  @override
  void initState() {
    super.initState();
    if (widget.category == null) {
      _title = '';
      _iconCodePoint = Icons.add_circle_outline.codePoint;
    } else {
      _title = widget.category!.title;
      _iconCodePoint = widget.category!.iconCodePoint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _title,
                        decoration: const InputDecoration(hintText: 'Title'),
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
                    ),
                    IconButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(16)),
                      ),
                      icon: Icon(IconData(_iconCodePoint,
                          fontFamily: 'MaterialIcons')),
                      onPressed: () async {
                        final icon = await showDialog<IconData>(
                            context: context,
                            builder: (context) => IconPicker(widget: widget));
                        if (icon != null) {
                          setState(() {
                            _iconCodePoint = icon.codePoint;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        addOrUpdateCategory();
                      },
                      child: Text(widget.category == null ? 'Add' : 'Update'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addOrUpdateCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_iconCodePoint == Icons.add_circle_outline.codePoint) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an icon')),
        );
        return;
      }
      if (widget.category == null) {
        await addCategory();
      } else {
        await updateCategory();
      }
      Navigator.of(context).pop();
    }
  }

  Future addCategory() async {
    final category = Category(
      title: _title,
      iconCodePoint: _iconCodePoint,
      categoriesType: 0,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
    );

    await CategoriesDatabases.instance.create(category);
  }

  Future updateCategory() async {
    final category = await widget.category!.copy(
      title: _title,
      iconCodePoint: _iconCodePoint,
      updatedAt: DateTime.now().toString(),
    );

    await CategoriesDatabases.instance.update(category);
  }
}

class IconPicker extends StatelessWidget {
  const IconPicker({
    super.key,
    required this.widget,
  });

  final CategoryAddPage widget;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Pick an icon'),
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: 400,
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 4, // change this number as needed
              children: widget.iconDataList.map((iconData) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop(iconData);
                  },
                  child: Icon(iconData),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
