import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';
import 'package:fp_ppb_expense_tracker/model/categories.dart';
import 'package:fp_ppb_expense_tracker/pages/category_add_page.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/categories.dart';

class CategoryDetailPage extends StatefulWidget {
  final Category? category;
  const CategoryDetailPage ({super.key, this.category});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {

  late String _title;
  late int _iconCodePoint;

  @override
  void initState() {
    super.initState();
    _title = widget.category!.title;
    _iconCodePoint = widget.category!.iconCodePoint;
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
            const SizedBox(width: 16),
            Text(_title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, size: 24),
            onPressed: () async {
              await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  useSafeArea: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryAddPage(iconDataList: iconDataList, category: widget.category,)
                        ],
                      ),
                    );
                  });
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 24),
            onPressed: () async {
              print(widget.category!.id);
              await CategoriesDatabases.instance.delete(widget.category!.id!);
              Navigator.of(context).pop();
            },
          ),
        ],
        centerTitle: true,
      ),
    );
  }
}
