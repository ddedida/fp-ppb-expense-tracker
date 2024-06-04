import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/savings.dart';

class SavingsAddPage extends StatefulWidget {
  final Savings? savings;
  const SavingsAddPage({super.key, this.savings});

  @override
  State<SavingsAddPage> createState() => _SavingsAddPageState();
}

class _SavingsAddPageState extends State<SavingsAddPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late DateTime _date;
  late String _emoji;
  late double _target;

  @override
  void initState() {
    super.initState();
    if (widget.savings == null) {
      _title = '';
      _amount = 0.0;
      _date = DateTime.now();
      _emoji = '😁';
      _target = 0.0;
    } else {
      _title = widget.savings!.title;
      _amount = widget.savings!.amount;
      _date = DateTime.fromMicrosecondsSinceEpoch(widget.savings!.date);
      _emoji = widget.savings!.emoji;
      _target = widget.savings!.target;
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
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final emoji = await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 300,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                            ),
                            itemBuilder: (context, index) {
                              final emoji =
                                  String.fromCharCodes([index + 0x1F600]);
                              return GestureDetector(
                                child: GridTile(
                                  child: Center(
                                    child: Text(
                                      emoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context, emoji);
                                },
                              );
                            },
                          ),
                        );
                      },
                    );

                    if (emoji != null) {
                      setState(() {
                        _emoji = emoji;
                      });
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        _emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
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
              ],
            ),
            TextFormField(
              initialValue: _amount.toString(),
              decoration: const InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
              onSaved: (value) {
                _amount = double.parse(value!);
              },
            ),
            InputDatePickerFormField(
              initialDate: _date,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateSaved: (date) {
                _date = date;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final savings = Savings(
                    title: _title,
                    amount: _amount,
                    date: _date.microsecondsSinceEpoch,
                    emoji: _emoji,
                    target: _target,
                    createdAt: DateTime.now().millisecondsSinceEpoch,
                    updatedAt: DateTime.now().millisecondsSinceEpoch,
                  );

                  Navigator.pop(context, savings);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ));
  }
}
