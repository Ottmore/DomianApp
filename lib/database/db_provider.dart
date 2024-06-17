import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  MySQLConnection? _database;

  Future<MySQLConnection?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }



  initDB() async {
    final conn = await MySQLConnection.createConnection(
      host: dotenv.env['DB_HOST'],
      port: int.parse(dotenv.env['DB_PORT']!),
      userName: dotenv.env['DB_USERNAME']!,
      password: dotenv.env['DB_PASSWORD']!,
      databaseName: dotenv.env['DB_DATABASE'],
    );
    await conn.connect();

    return conn;
  }
}