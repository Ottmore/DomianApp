import 'package:domian/constants/constants.dart';
import 'package:domian/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:domian/widgets/bottom_app_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  String fullName = "";
  String profileImage = "";

  late Box userBox;
  late Box userProfileBox;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('user');
    userProfileBox = Hive.box('user_profile');

    if (userProfileBox.length > 0) {
      final userProfile = userProfileBox.getAt(0);

      fullName = "${userProfile['first_name']} ${userProfile['last_name']}";
      profileImage = userProfile['profile_image'];
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (userBox.length == 0) {
        Navigator.pushNamed(context, '/login');
      }
    });

    void _menuOpen() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Админ панель',
                  style: TextStyle(fontSize: 25),
                ),
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
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cdomian,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                elevation: 5,
                                fixedSize: const Size(250, 56),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Добавить объект',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cdomian,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                elevation: 5,
                                fixedSize: const Size(250, 56),
                              ),
                              icon: const Icon(Icons.house, color: Colors.white),
                              label: const Text(
                                'Изменить объект',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cdomian,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                elevation: 5,
                                fixedSize: const Size(250, 56),
                              ),
                              icon: const Icon(Icons.account_circle,
                                  color: Colors.white),
                              label: const Text(
                                'Добавить агента',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  )
              );
            }
            ),
          );
        }

    print(profileImage);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Личный кабинет',
          style: TextStyle(fontSize: 25, color: black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _menuOpen,
            icon: const Icon(Icons.accessibility_new_sharp),
          )
        ],
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage('assets/user/$profileImage'),
                  backgroundColor: Colors.black12,
                ),
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
              ElevatedButton.icon(
                onPressed: () {
                  print('Просмотр избранного');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: cdomian,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    elevation: 5,
                    fixedSize: const Size(250, 56)),
                icon: const Icon(Icons.favorite, color: Colors.white),
                label: const Text(
                  'Просмотр избранного',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  navigateWithSlide(context, '/setting');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: cdomian,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    elevation: 5,
                    fixedSize: const Size(250, 56)),
                icon: const Icon(Icons.settings, color: Colors.white),
                label: const Text(
                  'Настройки аккаунта',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () async {
                  userBox.clear();
                  userProfileBox.clear();
                  navigateWithSlide(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: cdomian,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    elevation: 5,
                    fixedSize: const Size(250, 56)),
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text(
                  'Выход из аккаунта',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
