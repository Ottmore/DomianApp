import 'dart:io';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:domian/model/user.dart';
import 'package:domian/model/userProfile.dart';
import 'package:hive/hive.dart';

class UserService {
  getRemoteImage(int userId, String fileName) async {
    final socket = await SSHSocket.connect(
      dotenv.env['SFTP_HOST']!,
        int.parse(dotenv.env['SFTP_PORT']!)
    );

    final client = SSHClient(
      socket,
      username: dotenv.env['SFTP_USERNAME']!,
      onPasswordRequest: () => dotenv.env['SFTP_PASSWORD'],
    );

    final sftp = await client.sftp();
    final item = await sftp.open('${dotenv.env['SFTP_PATH']}/users/$userId/$fileName');
    final content = await item.readBytes();

    client.close();
    await client.done;

    return content;
  }

  Future<Map<String, dynamic>> saveProfile(String email, String password, String firstName, String? lastName, String phoneNumber, String? dateOfBirthday, String profileImage) async {
    final userBox = Hive.box('user');
    final userProfileBox = Hive.box('user_profile');

    User user = userBox.getAt(0);
    UserProfile userProfile = userProfileBox.getAt(0);

    user.email = email;
    user.password = password;
    user.updated_at = DateTime.now();

    userProfile.first_name = firstName;
    userProfile.last_name = lastName;
    userProfile.phone_number = phoneNumber;
    userProfile.date_of_birth = dateOfBirthday;
    userProfile.profile_image = profileImage;

    UserModel().update(user.id!, user.toMap());
    UserProfileModel().update(userProfile.id!, userProfile.toMap());

    await user.save();
    await userProfile.save();

    return {
      'message': 'Профиль изменён',
    };
  }

  saveImage(String filePath, String fileName, String userDirectory) async {
    final socket = await SSHSocket.connect(
        dotenv.env['SFTP_HOST']!,
        int.parse(dotenv.env['SFTP_PORT']!)
    );

    final client = SSHClient(
      socket,
      username: dotenv.env['SFTP_USERNAME']!,
      onPasswordRequest: () => dotenv.env['SFTP_PASSWORD'],
    );

    final sftp = await client.sftp();

    await sftp.mkdir('${dotenv.env['SFTP_PATH']}/users/$userDirectory');

    final file = await sftp.open('${dotenv.env['SFTP_PATH']}/users/$userDirectory/$fileName', mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
    await file.write(File(filePath).openRead().cast());

    client.close();
    await client.done;
  }
}