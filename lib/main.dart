import 'package:domian/model/user.dart';
import 'package:domian/model/userProfile.dart';
import 'package:domian/routes/router.dart';
import 'package:domian/routes/slide_page_route.dart';
import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  await Hive.openBox('user');
  await Hive.openBox('user_profile');

  runApp(const DomianApp());
}

class DomianApp extends StatelessWidget {
  const DomianApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: white,
      ),
      initialRoute: '/',
      routes: router(),
    );
  }
}
