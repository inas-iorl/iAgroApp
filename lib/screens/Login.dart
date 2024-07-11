import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/api.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var api = GetIt.I<Api>();
  bool loading = false;

  TextEditingController _login = TextEditingController();
  TextEditingController _pass = TextEditingController();

  final ButtonStyle button_style =
  ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    textStyle: TextStyle(color: Colors.white),
    foregroundColor: Colors.grey,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> logIn() async {
    var response = await api.logIn(_login.text, _pass.text);
    if (response['success']){Navigator.of(context).pushNamed('/');}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text('Вход'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Войти', style: TextStyle(color: Colors.white, fontSize: 20)),
              loginFormField(label: 'Введите номер телефона', controller: _login, keyboard: TextInputType.phone),
              loginFormField(label: 'Введите пароль', controller: _pass, keyboard: TextInputType.text, obscure: true),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,8,0,0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey[300],
                    ),
                      onPressed: (){logIn();},
                      child: Text('Продолжить')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class loginFormField extends StatelessWidget {
  loginFormField({required this.label, required this.controller, required this.keyboard, this.obscure = false});
  String label;
  TextEditingController controller;
  TextInputType keyboard;
  bool obscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,4,0,0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboard,
        decoration: InputDecoration(
          // label: Text('Номер'),
            fillColor: Colors.blueGrey[400],
            filled: true,
            hintStyle: TextStyle(color: Colors.white),
            hintText: label,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey))
        ),
      ),
    );
  }
}
