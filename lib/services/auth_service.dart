import 'package:domian/model/user.dart';
import 'package:domian/model/userProfile.dart';

class AuthService {
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    User? user = await UserModel().getByEmail(email);

    if (user?.password == password) {
      return {
        'message': 'Успешная авторизация',
        'user': user,
        'isAuth': true
      };
    } else {
      return {
        'message': 'Неправильный email или пароль',
        'user': null,
        'isAuth': false
      };
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password, String firstName, String? lastName, String phoneNumber, String? dateOfBirthday) async {
    User? user = await UserModel().getByEmail(email);

    if (user != null) {
      return {
        'message': 'Пользователь с таким email уже существует',
        'isRegister': false
      };
    }

    Map<String, dynamic> userMap = {
      'email': email,
      'password': password,
      'is_agent': 0,
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
    };

    Map<String, dynamic> userProfileMap = {
      'first_name': firstName,
      'last_name': lastName,
      'description': null,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirthday,
      'profile_image': null,
    };

    UserModel().create(User.fromMap(userMap));
    UserProfileModel().create(UserProfile.fromMap(userProfileMap));

    User? createdUser = await UserModel().getByEmail(email);

    return {
      'user': createdUser,
      'message': 'Успешная регистрация',
      'isRegister': true
    };
  }
}
