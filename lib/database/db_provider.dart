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
      host: "",
      port: 3306,
      userName: "root",
      password: "1234",
      databaseName: "domian", // optional
    );
    await conn.connect();

    return conn;
  }
}