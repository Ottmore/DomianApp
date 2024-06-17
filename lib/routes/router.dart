import 'package:domian/screens/search/search_screen.dart';
import 'package:domian/screens/user/favorite/user_favorite.dart';
import 'package:flutter/material.dart';
import 'package:domian/routes/slide_page_route.dart';
import 'package:domian/screens/home/home_screen.dart';
import 'package:domian/screens/login/login_screen.dart';
import 'package:domian/screens/registration/registration_screen.dart';
import 'package:domian/screens/reviews/reviews_screen.dart';
import 'package:domian/screens/user/profile/user_profile.dart';
import 'package:domian/screens/user/settings/user_settings.dart';
import 'package:domian/screens/user/admin/add_object/addObject_screen.dart';

Map<String, WidgetBuilder> router() {
  return {
    '/': (BuildContext context) => const HomeScreen(),
    '/search': (BuildContext context) => const SearchScreen(),
    '/reviews': (BuildContext context) => const ReviewsScreen(),
    '/user-profile': (BuildContext context) => const UserProfileScreen(),
    '/favorites': (BuildContext context) => const UserFavorite(),
    '/setting': (BuildContext context) => const UserSettingsScreen(),
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegistrationScreen(),
    '/add-object': (BuildContext context) => CreateObjectScreen(),
  };
}

void navigateWithSlide(BuildContext context, String routeName) {
  if (ModalRoute.of(context)?.settings.name != routeName) {
    Navigator.of(context).push(SlidePageRoute(page: router()[routeName]!(context)));
  }
}