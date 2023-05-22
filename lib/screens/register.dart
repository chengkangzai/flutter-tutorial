import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  String errorMessage = '';
  String deviceName = '';

  @override
  void initState() {
    getDeviceName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 8,
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter name';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          errorMessage = '';
                        }),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter email';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          errorMessage = '';
                        }),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter password';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          errorMessage = '';
                        }),
                        keyboardType: TextInputType.visiblePassword,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                      ),
                      TextFormField(
                        controller: confirmedPasswordController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please Enter confirmedPassword';
                          }
                          return null;
                        },
                        onChanged: (text) => setState(() {
                          errorMessage = '';
                        }),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: const InputDecoration(
                            labelText: 'Confirmed Password'),
                      ),
                      ElevatedButton(
                        onPressed: () => submit(),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 36),
                        ),
                        child: const Text('Login'),
                      ),
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                            onTap: () {
                              // Navigator.pop(context);
                              Navigator.pushNamed(context, '/categories');
                            },
                            child: const Text('Go back to login page')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future submit() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    final AuthProvider provider = Provider.of(context, listen: false);

    try {
      await provider.register(
          nameController.text,
          emailController.text,
          passwordController.text,
          confirmedPasswordController.text,
          deviceName);

      Navigator.pop(context);
    } catch (exception) {
      setState(() {
        errorMessage = exception.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> getDeviceName() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = build.model;
        });
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = build.model;
        });
      }
    } on PlatformException {
      setState(() {
        deviceName = 'error';
      });
    }
  }
}
