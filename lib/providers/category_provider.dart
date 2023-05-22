import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/services/api.dart';

import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  late ApiService apiService;
  List<Category> categories = [];
  late AuthProvider authProvider;

  CategoryProvider(this.authProvider) {
    apiService = ApiService(authProvider.token);

    init();
  }

  Future init() async {
    categories = await apiService.fetchCategory();

    notifyListeners();
  }

  Future add(Category category) async {
    try {
      Category newCategory = await apiService.createCategory(category);
      categories.add(newCategory);

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }

  Future update(Category category) async {
    try {
      Category updatedCategory = await apiService.updateCategory(category);
      int index = categories.indexOf(category);
      categories[index] = updatedCategory;

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }

  Future delete(Category category) async {
    try {
      apiService.deleteCategory(category);
      categories.remove(category);

      notifyListeners();
    } catch (e) {
      await authProvider.logout();
    }
  }
}
