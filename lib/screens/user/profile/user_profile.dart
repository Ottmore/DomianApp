import 'package:domian/constants/constants.dart';
import 'package:domian/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:domian/widgets/bottom_app_bar.dart';
import 'package:domian/services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String fullName = "";
  bool checkIsAgent = false;
  late ImageProvider<Object> _profileImage;

  late Box userBox;
  late Box userProfileBox;

  late Map<dynamic, dynamic> user;
  late Map<dynamic, dynamic> userProfile;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('user');
    userProfileBox = Hive.box('user_profile');

    if (userProfileBox.length > 0) {
      user = userBox.getAt(0);
      userProfile = userProfileBox.getAt(0);

      fullName = "${userProfile['first_name']} ${userProfile['last_name']}";
      checkIsAgent = user['is_agent'] == true;

      _loadData();
    }
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
    Future.delayed(Duration.zero, () {
      if (userBox.length == 0) {
        Navigator.pushNamed(context, '/login');
      }
    });

    void _showNotAgentDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Вы не являетесь агентом.'),
            actions: <Widget>[
              TextButton(
                child: const Text('ОК'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _adminMenuOpen() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Админ панель', style: TextStyle(fontSize: 25)),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildAdminButton(
                          icon: Icons.add,
                          label: 'Добавить объект',
                          onPressed: () {
                            Navigator.pushNamed(context, '/add-object');
                          },
                        ),
                        const SizedBox(height: 32),
                        _buildAdminButton(
                          icon: Icons.house,
                          label: 'Изменить объект',
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                        const SizedBox(height: 32),
                        _buildAdminButton(
                          icon: Icons.account_circle,
                          label: 'Добавить агента',
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Личный кабинет', style: TextStyle(fontSize: 25, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          /*IconButton(
            onPressed: () {
              if (checkIsAgent) {
                _adminMenuOpen();
              } else {
                _showNotAgentDialog();
              }
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          )
        */],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? const CircularProgressIndicator()
                    : CircleAvatar(
                  radius: 120,
                  backgroundImage: _profileImage,
                  backgroundColor: Colors.grey.shade200,
                ),
                const SizedBox(height: 16),
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                _buildProfileButton(
                  icon: Icons.favorite,
                  label: 'Просмотр избранного',
                  onPressed: () {
                    navigateWithSlide(context, '/favorites');
                  },
                ),
                const SizedBox(height: 32),
                _buildProfileButton(
                  icon: Icons.settings,
                  label: 'Настройки аккаунта',
                  onPressed: () {
                    navigateWithSlide(context, '/setting');
                  },
                ),
                const SizedBox(height: 32),
                _buildProfileButton(
                  icon: Icons.exit_to_app,
                  label: 'Выход из аккаунта',
                  onPressed: () async {
                    await userBox.clear();
                    await userProfileBox.clear();
                    navigateWithSlide(context, '/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }

  ElevatedButton _buildProfileButton({required IconData icon, required String label, required void Function() onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cdomian,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 5,
        fixedSize: const Size(250, 56),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  ElevatedButton _buildAdminButton({required IconData icon, required String label, required void Function() onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: cdomian,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 5,
        fixedSize: const Size(250, 56),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
