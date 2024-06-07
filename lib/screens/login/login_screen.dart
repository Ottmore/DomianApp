import 'dart:ui';

import 'package:domian/model/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:domian/services/auth_service.dart';

import 'package:domian/widgets/bottom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Box user;
  late Box userProfile;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    Hive.close();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      final user = Hive.box('user');
      final userProfile = Hive.box('user_profile');

      Map<String, dynamic> authData = await AuthService().signIn(email, password);

      print(authData);

      if (authData['isAuth']) {
        Map<String, dynamic> authUser = authData['user'].toMap();

        UserProfile userProfileObject = await UserProfileModel().getById(authUser['id']);

        await user.add(authUser);
        await userProfile.add(userProfileObject.toMap());

        pushToProfile();
      }
    }
  }

  pushToProfile() {
    Navigator.pushNamed(context, '/user-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Добро пожаловать',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Войдите в свой аккаунт',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Эл. почта',
                    labelStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите свою эл. почту';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Пожалуйста, введите корректный адрес эл. почты';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    fillColor: Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.redAccent),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите свой пароль';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Войти',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text('Нет аккаунта?'),
                GestureDetector(
                  onTap:(){
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('Зарегистрируйся',
                    style: TextStyle(
                        color: Colors.redAccent,
                        decoration: TextDecoration.underline
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}