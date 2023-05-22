import 'package:flutter/material.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/providers/category_provider.dart';
import 'package:my_app/providers/transaction_provider.dart';
import 'package:my_app/screens/categories.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/register.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => CategoryProvider(authProvider),
              ),
              ChangeNotifierProvider(
                create: (context) => TransactionProvider(authProvider),
              ),
            ],
            child: MaterialApp(
              theme: ThemeData(
                useMaterial3: true,
              ),
              routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return const Home();
                  } else {
                    return const Login();
                  }
                },
                '/login': (context) => const Login(),
                '/register': (context) => const Register(),
                '/home': (context) => const Home(),
                '/categories': (context) => const Categories()
              },
            ),
          );
        },
      ),
    );
  }
}
