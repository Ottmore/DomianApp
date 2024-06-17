import 'package:domian/database/db_provider.dart';

class BaseModel {
  late String table;

  getById(int id) async {
    final conn = await DBProvider.db.database;
    final results = await conn?.execute('SELECT * FROM `$table` WHERE id=$id');

    if (results!.numOfRows > 0) {
      return results.rows.first.assoc();
    }
  }

  getAll() async {
    final conn = await DBProvider.db.database;
    final results = await conn?.execute('SELECT * FROM `$table`');

    if (results!.numOfRows > 0) {
      return results.rows;
    }
  }

  delete(int id) async {
    final conn = await DBProvider.db.database;
    await conn?.execute('DELETE FROM `$table` WHERE id=$id');
  }

  update(int id, Map<String, dynamic> columns, {columnId = 'id'}) async {
    List<String> stringColumns = [];

    for (var column in columns.entries) {
      stringColumns.add('${column.key}="${column.value}"');
    }

    final conn = await DBProvider.db.database;
    await conn?.execute('UPDATE `$table` SET ${stringColumns.join(', ')} WHERE $columnId=$id');
  }
}