import 'package:flutter/cupertino.dart';
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

  List<IconData> icons = [
    Icons.home,
    Icons.sports_soccer,
    Icons.fastfood,
    Icons.videogame_asset,
    Icons.stacked_line_chart,
    Icons.sports_motorsports,
    Icons.emoji_transportation,
    Icons.shopping_cart,
    Icons.medication,
    Icons.school,
    Icons.card_giftcard,
    Icons.shield,
    Icons.monetization_on,
    Icons.favorite,
    Icons.star,
  ];

  IconData? selectedIcon;

  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _iconTitle;

  @override
  void initState() {
    super.initState();
    if (widget.category == null) {
      _title = '';
      _iconTitle = 'home';
      selectedIcon = Icons.home;
    } else {
      _title = widget.category!.title!;
      _iconTitle = widget.category!.iconTitle!;
      selectedIcon = _getIconDataFromTitle(_iconTitle);
    }
  }

  IconData _getIconDataFromTitle(String iconTitle) {
    // Map icon title to IconData
    switch (iconTitle) {
      case 'home':
        return Icons.home;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'fastfood':
        return Icons.fastfood;
      case 'videogame_asset':
        return Icons.videogame_asset;
      case 'stacked_line_chart':
        return Icons.stacked_line_chart;
      case 'sports_motorsports':
        return Icons.sports_motorsports;
      case 'emoji_transportation':
        return Icons.emoji_transportation;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'medication':
        return Icons.medication;
      case 'school':
        return Icons.school;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'shield':
        return Icons.shield;
      case 'monetize_on':
        return Icons.monetization_on;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      default:
        return Icons.help; // default icon
    }
  }

  String _getTitleFromIconData(IconData iconData) {
    // Map IconData to icon title
    if (iconData == Icons.home) return 'Icons.home';
    if (iconData == Icons.sports_soccer) return 'Icons.sports_soccer';
    if (iconData == Icons.fastfood) return 'Icons.fastfood';
    if (iconData == Icons.videogame_asset) return 'Icons.videogame_asset';
    if (iconData == Icons.stacked_line_chart) return 'Icons.stacked_line_chart';
    if (iconData == Icons.sports_motorsports) return 'Icons.sports_motorsports';
    if (iconData == Icons.emoji_transportation) return 'Icons.emoji_transportation';
    if (iconData == Icons.shopping_cart) return 'Icons.shopping_cart';
    if (iconData == Icons.medication) return 'Icons.medication';
    if (iconData == Icons.school) return 'Icons.school';
    if (iconData == Icons.card_giftcard) return 'Icons.card_giftcard';
    if (iconData == Icons.shield) return 'Icons.shield';
    if (iconData == Icons.monetization_on) return 'Icons.monetization_on';
    if (iconData == Icons.favorite) return 'Icons.favorite';
    if (iconData == Icons.star) return 'Icons.star';
    return 'Icons.help'; // default icon title
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
        titleTextStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Title',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                cursorHeight: 20.0,
                initialValue: _title,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    hintText: 'Enter Title',
                    hintStyle: TextStyle(fontWeight: FontWeight.normal)
                ),
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
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Icon',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icons[index];
                            _iconTitle = _getTitleFromIconData(selectedIcon!);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIcon == icons[index]
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icons[index],
                            size: 26,
                            color: selectedIcon == icons[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    }
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    addOrUpdateCategory();
                  },
                  child: Text(
                    widget.category == null ? 'Add' : 'Update',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
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
      if (selectedIcon == null) {
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
}