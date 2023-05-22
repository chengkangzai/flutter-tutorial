import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_app/models/transaction.dart';

import '../models/category.dart';

class ApiService {
  late String token;

  final String baseUrl = 'https://c059-202-186-60-172.ngrok-free.app/api';

  ApiService(this.token);

  Future<List<Category>> fetchCategory() async {
    http.Response response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future createCategory(Category category) async {
    http.Response response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode({'name': category.name}),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<Category> updateCategory(Category category) async {
    http.Response response = await http.put(
      Uri.parse('$baseUrl/categories/${category.id}'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode({
        'name': category.name,
      }),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future deleteCategory(Category category) async {
    http.Response response = await http.delete(
      Uri.parse('$baseUrl/categories/${category.id}'),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }
  }

  Future<List<Transaction>> fetchTransaction() async {
    http.Response response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    List transactions = jsonDecode(response.body);

    print(transactions);

    return transactions
        .map((transaction) => Transaction.fromJson(transaction))
        .toList();
  }

  Future createTransaction(Transaction transaction) async {
    http.Response response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode({
        'category_id': transaction.categoryId,
        'transaction_date': transaction.transactionDate.toString(),
        'amount': transaction.amount,
        'description': transaction.description,
      }),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<Transaction> updateTransaction(Transaction transaction) async {
    http.Response response = await http.put(
      Uri.parse('$baseUrl/transactions/${transaction.id}'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode({
        'category_id': transaction.categoryId,
        'transaction_date': transaction.transactionDate.toString(),
        'amount': transaction.amount,
        'description': transaction.description,
      }),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future deleteTransaction(Transaction transaction) async {
    http.Response response = await http.delete(
      Uri.parse('$baseUrl/transactions/${transaction.id}'),
    );

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirmed, String deviceName) async {
    http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmed,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';

      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });

      throw Exception(errorMessage);
    }

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return response.body;
  }

  Future<String> login(String email, String password, String deviceName) async {
    http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_name': deviceName,
      }),
    );

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';

      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });

      throw Exception(errorMessage);
    }

    if (response.statusCode < 200 && response.statusCode > 300) {
      throw Exception('Opps! something goes wrong');
    }

    return response.body;
  }

  Future<String> logout() async {
    // http.Response response = await http.post(
    //   Uri.parse('$baseUrl/auth/login'),
    //   headers: {
    //     HttpHeaders.contentTypeHeader: 'application/json',
    //     HttpHeaders.acceptHeader: 'application/json',
    //   },
    //   body: jsonEncode({
    //     'email': email,
    //     'password': password,
    //     'device_name': deviceName,
    //   }),
    // );

    return '';
  }
}
