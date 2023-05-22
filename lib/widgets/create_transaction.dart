import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/category.dart';
import 'package:my_app/models/transaction.dart';
import 'package:my_app/providers/category_provider.dart';
import 'package:provider/provider.dart';

class CreateTransaction extends StatefulWidget {
  final Function callback;

  const CreateTransaction(this.callback, {Key? key}) : super(key: key);

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();

  late String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  setState(() {
                    errorMessage = '';
                  });
                },
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter amount';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                  icon: Icon(Icons.attach_money),
                ),
              ),
            ),
            buildCategoryDropDown(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: descriptionController,
                onChanged: (String value) {
                  setState(() {
                    errorMessage = '';
                  });
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please enter description';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: dateController,
                onTap: () {
                  selectDate(context);
                },
                onChanged: (String value) {
                  setState(() {
                    errorMessage = '';
                  });
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Please select a date';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => saveCategory(),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Future saveCategory() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    Transaction transaction = Transaction(
      categoryId: int.parse(categoryController.text),
      transactionDate: dateController.text,
      amount: int.parse(amountController.text),
      description: descriptionController.text,
    );

    await widget.callback(transaction);

    Navigator.pop(context);
  }

  buildCategoryDropDown() {
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      List<Category> categories = categoryProvider.categories;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField(
          items: categories.map<DropdownMenuItem<String>>((Category e) {
            return DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text(
                e.name,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            setState(() {
              categoryController.text = value;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Please select category';
            }
            return null;
          },
        ),
      );
    });
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }
}
