import 'package:flutter/material.dart';
import 'package:my_app/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../widgets/create_transaction.dart';
import '../widgets/edit_transaction.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  TransactionsState createState() => TransactionsState();
}

class TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = provider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          Transaction transaction = transactions[index];

          return ListTile(
            title: Text('\$${transaction.amount}'),
            subtitle: Text(transaction.categoryName ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(transaction.transactionDate),
                        Text(transaction.description)
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      builder: (context) {
                        return EditTransaction(transaction, provider.update);
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirmation'),
                          content: const Text(
                              'Are you sure you want to delete this transaction?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No, keep it'),
                            ),
                            TextButton(
                              onPressed: () => deleteTransaction(
                                  provider.delete, transaction),
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                'Yes, delete it',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (context) {
              return CreateTransaction(provider.add);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future deleteTransaction(Function callback, Transaction transaction) async {
    await callback(transaction);

    Navigator.pop(context);
  }
}
