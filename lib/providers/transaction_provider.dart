import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/services/api.dart';

import '../models/transaction.dart';

class TransactionProvider extends ChangeNotifier {
  late ApiService apiService;
  List<Transaction> transactions = [];
  late AuthProvider authProvider;

  TransactionProvider(this.authProvider) {
    apiService = ApiService(authProvider.token);

    init();
  }

  Future init() async {
    transactions = await apiService.fetchTransaction();

    notifyListeners();
  }

  Future add(Transaction transaction) async {
    try {
      Transaction newTransaction =
          await apiService.createTransaction(transaction);
      transactions.add(newTransaction);

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }

  Future update(Transaction transaction) async {
    try {
      Transaction updatedTransaction =
          await apiService.updateTransaction(transaction);
      int index = transactions.indexOf(transaction);
      transactions[index] = updatedTransaction;

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }

  Future delete(Transaction transaction) async {
    try {
      apiService.deleteTransaction(transaction);
      transactions.remove(transaction);

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }
}
