import 'package:flutter/material.dart';
import 'package:my_app/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isAuthenticated = false;
  late String token;

  late ApiService apiService = ApiService('');

  AuthProvider() {
    init();
  }

  Future<void> init() async {
    token = await getToken();
    if (token.isNotEmpty) {
      isAuthenticated = true;
    }
    apiService = ApiService(token);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password,
      String passwordConfirmed, String deviceName) async {
    token = await apiService.register(
      name,
      email,
      password,
      passwordConfirmed,
      deviceName,
    );
    isAuthenticated = true;
    setToken(token);

    notifyListeners();
  }

  Future<void> login(String email, String password, String deviceName) async {
    token = await apiService.login(email, password, deviceName);
    isAuthenticated = true;
    setToken(token);

    notifyListeners();
  }

  Future<void> logout() async {
    token = '';
    isAuthenticated = false;
    setToken('');

    notifyListeners();
  }

  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
