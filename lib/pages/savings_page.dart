import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/db/savings.dart';
import 'package:fp_ppb_expense_tracker/model/savings.dart';
import 'package:fp_ppb_expense_tracker/pages/savings_add_page.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({Key? key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  late List<Savings> savings;
  bool isLoading = false;

  Future refreshSavings() async {
    setState(() => isLoading = true);
    savings = await SavingsDatabases.instance.readAllSavings();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    refreshSavings();
  }

  @override
  void dispose() {
    SavingsDatabases.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : savings.isEmpty
                ? const Text('No savings')
                : buildCard(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              useSafeArea: true,
              builder: (context) {
                return const SizedBox(
                  child: SavingsAddPage(),
                );
              }).then((_) => refreshSavings());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCard() => ListView.builder(
        itemCount: savings.length,
        itemBuilder: (context, index) {
          final saving = savings[index];
          return Card(
            margin: const EdgeInsets.all(8),
            elevation: 4,
            child: ListTile(
              title: Text(saving.title),
              subtitle: Text(saving.amount.toString()),
              trailing: Text(saving.target.toString()),
              onTap: () async {
                await Navigator.pushNamed(context, '/savings/add',
                    arguments: saving);
                refreshSavings();
              },
            ),
          );
        },
      );
}
