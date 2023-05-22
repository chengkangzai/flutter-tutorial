import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/category.dart';
import 'package:my_app/models/transaction.dart';
import 'package:my_app/providers/category_provider.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final Function callback;
  final Transaction transaction;

  const EditTransaction(this.transaction, this.callback, {Key? key})
      : super(key: key);

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();

  late String errorMessage = '';

  @override
  void initState() {
    amountController.text = widget.transaction.amount.toString();
    descriptionController.text = widget.transaction.description;
    var date = DateTime.parse(widget.transaction.transactionDate);
    dateController.text = DateFormat('MM/dd/yyyy').format(date);
    categoryController.text = widget.transaction.categoryId.toString();
    super.initState();
  }

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
                  onPressed: () => updateCategory(),
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

  Future updateCategory() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    widget.transaction.amount = int.parse(amountController.text);
    widget.transaction.categoryId = int.parse(categoryController.text);
    widget.transaction.description = descriptionController.text;
    widget.transaction.transactionDate = dateController.text;

    await widget.callback(widget.transaction);

    Navigator.pop(context);
  }

  buildCategoryDropDown() {
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      List<Category> categories = categoryProvider.categories;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField(
          elevation: 8,
          items: categories.map<DropdownMenuItem<String>>((Category e) {
            return DropdownMenuItem<String>(
              value: e.id.toString(),
              child: Text(
                e.name,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          value: categoryController.text,
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
