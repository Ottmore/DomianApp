import 'package:flutter/material.dart';
import 'package:domian/routes/slide_page_route.dart';
import 'package:domian/screens/home/home_screen.dart';
import 'package:domian/screens/login/login_screen.dart';
import 'package:domian/screens/registration/registration_screen.dart';
import 'package:domian/screens/reviews/reviews_screen.dart';
import 'package:domian/screens/user/profile/user_profile.dart';
import 'package:domian/screens/user/settings/user_settings.dart';

Map<String, WidgetBuilder> router() {
  return {
    '/': (BuildContext context) => const HomeScreen(),
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegistrationScreen(),
    '/user-profile': (BuildContext context) => const UserProfileScreen(),
    '/reviews': (BuildContext context) => const ReviewsScreen(),
    '/setting': (BuildContext context) => const UserSettingsScreen(),
  };
}

void navigateWithSlide(BuildContext context, String routeName) {
  if (ModalRoute.of(context)?.settings.name != routeName) {
    Navigator.of(context).push(SlidePageRoute(page: router()[routeName]!(context)));
  }
}