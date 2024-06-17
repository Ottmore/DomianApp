import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:domian/constants/constants.dart';
import 'package:domian/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  late TextEditingController _emailController;
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  late ImageProvider<Object> _profileImage;

  XFile? _uploadedImage;

  late Box userBox;
  late Box userProfileBox;

  late Map<dynamic, dynamic> user;
  late Map<dynamic, dynamic> userProfile;

  bool _isLoading = true;

  Future<void> _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = img?.path != null
          ? FileImage(File(img!.path)) as ImageProvider
          : AssetImage('assets/user/${userProfile['profile_image']}') as ImageProvider;

      _uploadedImage = img;
    });
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      String password = _passwordController.text;
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      if (_uploadedImage != null) {
        UserService().saveImage(_uploadedImage!.path, _uploadedImage!.name, user['id'].toString());
      }

      UserService().saveProfile(
          _emailController.text,
          hashedPassword,
          _lastNameController.text,
          _firstNameController.text,
          _phoneNumberController.text,
          _dateOfBirthController.text,
          _uploadedImage?.name ?? userProfile['profile_image']
      );

      Navigator.pushNamed(context, '/user-profile');
    }
  }

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('user');
    userProfileBox = Hive.box('user_profile');

    if (userProfileBox.length > 0) {
      user = userBox.getAt(0);
      userProfile = userProfileBox.getAt(0);
    }

    _emailController = TextEditingController(text: user['email']);
    _lastNameController = TextEditingController(text: userProfile['last_name']);
    _firstNameController = TextEditingController(text: userProfile['first_name']);
    _phoneNumberController = TextEditingController(text: userProfile['phone_number']);
    _dateOfBirthController = TextEditingController(text: userProfile['date_of_birth']);

    _loadData();
  }

  _loadData() async {
    if (userProfile['profile_image'] == 'profile_image_placeholder.png') {
      _profileImage = AssetImage('assets/user/${userProfile['profile_image']}');
    } else {
      final image = await UserService().getRemoteImage(user['id'], userProfile['profile_image']);

      _profileImage = MemoryImage(image);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки аккаунта'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _isLoading == false
                    ? GestureDetector(
                  onTap: _updateProfileImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _profileImage,
                    backgroundColor: Colors.redAccent,
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                    return 'Пожалуйста, введите ваш email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Пожалуйста, введите правильный email';
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
                    return 'Пожалуйста, введите ваш пароль';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Фамилия',
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
                    return 'Пожалуйста, введите вашу фамилию';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Имя',
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
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Номер телефона',
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
                    return 'Пожалуйста, введите ваш номер телефона';
                  }
                  if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                    return 'Пожалуйста, введите правильный номер телефона';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(
                  labelText: 'Дата рождения',
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
                    return 'Пожалуйста, введите вашу дату рождения';
                  }
                  if (!RegExp(r'^\d{2}.\d{2}.\d{4}$').hasMatch(value)) {
                    return 'Пожалуйста, введите дату рождения в формате ДД/ММ/ГГГГ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cdomian,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: Text(
                    'Сохранить изменения',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
