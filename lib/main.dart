import 'package:domian/model/user.dart';
import 'package:domian/model/userProfile.dart';
import 'package:domian/model/favorite.dart';
import 'package:domian/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await dotenv.load();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(FavoriteAdapter());
  await Hive.openBox('user');
  await Hive.openBox('user_profile');
  await Hive.openBox('favorites');
  await Hive.openBox('city');

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: white,
          progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.redAccent,
          )
      ),
      initialRoute: '/',
      routes: router(),
    );
  }
}
