import 'package:flutter/material.dart';
import 'package:my_app/providers/category_provider.dart';
import 'package:my_app/widgets/create_category.dart';
import 'package:my_app/widgets/edit_category.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);
    List<Category> categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          Category category = categories[index];

          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        return EditCategory(category, provider.update);
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
                              'Are you sure you want to delete this category?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No, keep it'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  deleteCategory(provider.delete, category),
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
              return CreateCategory(provider.add);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future deleteCategory(Function callback, Category category) async {
    await callback(category);

    Navigator.pop(context);
  }
}
