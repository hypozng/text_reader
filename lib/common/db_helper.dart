import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:text_reader/model.dart';
import 'package:text_reader/common.dart';

class DBHelper {
  /// 数据库文件名
  static const String db_name = "text_reader.db";

  /// 初始化文件
  static const String init_key= "assets/database_init.txt";

  /// 数据库版本
  static const int version = 2;

  static String _databasesPath;

  static sqflite.Database _database;

  static const _types = const<Type, String> {
    Book: "book",
    Chapter: "chapter"
  };

  /// 获取数据库存储路径
  static Future<String> get databasesPath async {
    return _databasesPath ??= await sqflite.getDatabasesPath();
  }

  static Future<sqflite.Database> get database async {
    return _database ??= await _open();
  }

  static Future<void> init() async => await database;

  /// 执行sql语句
  static Future<void> execute(String sql, [List<dynamic> arguments]) async {
    var db = await database;
    print("===> execute sql: $sql");
    print("===> arguments: $arguments");
    await db.execute(sql, arguments);
    print("===> result: void");
  }

  /// 执行sql查询语句
  static Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic> arguments]) async {
    var db = await database;
    print("===> execute sql: $sql");
    print("===> arguments: $arguments");
    var result = await db.rawQuery(sql, arguments);
    print("===> result: $result");
    return result;
  }

  /// 执行sql新增语句
  static Future<int> rawInsert(String sql, [List<dynamic> arguments]) async {
    var db = await database;
    print("===> execute sql: $sql");
    print("===> arguments: $arguments");
    var result = await db.rawInsert(sql, arguments);
    print("===> result: $result");
    return result;
  }

  /// 执行sql删除语句
  static Future<int> rawDelete(String sql, [List<dynamic> arguments]) async {
    var db = await database;
    print("===> execute sql: $sql");
    print("===> arguments: $arguments");
    var result = await db.rawDelete(sql, arguments);
    print("===> result: $result");
    return result;
  }

  /// 执行sql修改语句
  static Future<int> rawUpdate(String sql, [List<dynamic> arguments]) async {
    var db = await database;
    print("===> execute sql: $sql");
    print("===> arguments: $arguments");
    var result = await db.rawUpdate(sql, arguments);
    print("==> result: $result");
    return result;
  }

  static Future<T> findTable<T>(
    dynamic model,
    T defaultResult,
    Future<T> callback(String table, String id, Map<String, dynamic> data)
  ) async {
    if (model == null || callback == null) {
      return defaultResult;
    }
    try {
      String table = _types[model.runtimeType];
      if (table == null) {
        return defaultResult;
      }
      Map<String, dynamic> data = model.toJson();
      return await callback(table, data["id"], data);
    } catch(e) {
      print(e);
      return defaultResult;
    }
  }

  /// 判断数据库中是否存在指定实体数据
  static Future<bool> contains(dynamic model) async {
    return await findTable(model, false, (table, id, data) async {
      if (id?.isNotEmpty != true) {
        return false;
      }
      var result = await rawQuery("SELECT COUNT(1) AS count FROM $table WHERE id=?", [id]);
      return result[0]["count"] > 0;
    });
  }

  /// 保存数据
  static Future<bool> save(dynamic model) async {
    if (model?.id?.isNotEmpty == true) {
      return await update(model);
    }
    return await insert(model);
  }

  /// 新增数据
  static Future<bool> insert(dynamic model) async {
    model.id = uuid();
    return await findTable(model, false, (table, id, data) async {
      var sql = StringBuffer("INSERT INTO $table(");
      var values = StringBuffer();
      var arguments = List<dynamic>();
      var begin = false;
      data.forEach((key, value) {
        if (begin) {
          values.write(",");
          sql.write(",");
        } else {
          begin = true;
        }
        values.write("?");
        sql.write("$key");
        arguments.add(value);
      });
      sql.write(") VALUES(${values.toString()})");
      return await rawInsert(sql.toString(), arguments) > 0;
    });
  }

  /// 修改数据
  static Future<bool> update(dynamic model) async {
    return await findTable(model, false, (table, id, data) async {
      var sql = StringBuffer("UPDATE $table SET ");
      var arguments = List<dynamic>();
      var begin = false;
      sql.write("INSERT INTO $table(");
      data.forEach((key, value) {
        if (begin) {
          sql.write(",");
        } else {
          begin = true;
        }
        sql.write("$key=?");
        arguments.add(value);
      });
      return await rawInsert(sql.toString(), arguments) > 0;
    });
  }

  /// 删除数据
  static Future<bool> delete(dynamic model) async {
    return await findTable(model, false, (table, id, data) async {
      return await rawDelete("DELETE FROM $table WHERE id=?", [id]) > 0;
    });
  }

  /// 获取数据
  static Future<Map<String, dynamic>> get(Type type, String id) async {
    String table = _types[type];
    if (table == null) {
      return null;
    }
    var result = await rawQuery("SELECT * FROM $table WHERE id=?", [id]);
    if (result.isEmpty) {
      return null;
    }
    return result[0];
  }

  /// 获取数数据库中制定类型的所有实体
  static Future<List<T>> getAll<T>(Type type, T formatter(Map<String, dynamic> data)) async {
    String table = _types[type];
    if (table == null) {
      return [];
    }
    var result = await rawQuery("SELECT * FROM $table");
    return result.map<T>(formatter).toList();
  }

  static Future<List<Map<String, dynamic>>> find(dynamic example) async {
    return await findTable(example, [], (table, id, data) async {
      var sql = StringBuffer("SELECT * FROM $table WHERE");
      var arguments = [];
      var begin = false;
      data.forEach((key, value) {
        if (value == null) {
          return;
        }
        if (begin) {
          sql.write(" AND");
        } else {
          begin = true;
        }
        sql.write(" $key=?");
        arguments.add(value);
      });
      return await rawQuery(sql.toString(), arguments);
    });
  }

  /// 打开数据库
  static Future<sqflite.Database> _open() async {
    var dbpath = await databasesPath;
    return await sqflite.openDatabase(
      "$dbpath/$db_name",
      version: version,
      onCreate: (db, version) => _onUpgrade(db, 0, version),
      onUpgrade: _onUpgrade,
    );
  }

  /// 更新数据库时调用
  static Future<void> _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    var script = await _load();
    for (var i = oldVersion + 1; i <= newVersion; ++i) {
      for (var sql in script["version $i"]) {
        print("===> execute sql:\r\n$sql");
        await db.execute(sql);
      }
    }
  }

  /// 加载数据库初始化脚本
  static Future<Map<String, List<String>>> _load() async {
    var bundle = rootBundle ?? NetworkAssetBundle(Uri.directory(Uri.base.origin));
    var lines = (await bundle.loadString(init_key)).split("\r\n");
    Map<String, List<String>> result = Map<String, List<String>>();
    var command = "";
    var scripts = List<String>();
    var buffer = StringBuffer();
    var begin = false;
    var regCommand = RegExp(r"==== .+ ====");
    var parse = (String line) {
      if (regCommand.hasMatch(line)) {
        return "command:${line.substring(5, line.length - 5)}";
      }
      if (line == "----") {
        return "newline";
      }
      return null;
    };
    for (var line in lines) {
      if (line?.isNotEmpty != true) {
        continue;
      }
      var text = parse(line);
      if (text != null) {
        if (buffer.isNotEmpty) {
          scripts.add(buffer.toString());
        }
        begin = false;
        buffer = StringBuffer();
        if (text == "newline") {
          continue;
        }
        if (command?.isNotEmpty == true) {
          result[command] = scripts;
        }
        command = text.substring(text.indexOf(":") + 1);
        scripts = List<String>();
        continue;
      }
      if (begin) {
        buffer.write("\r\n");
      } else {
        begin = true;
      }
      buffer.write(line);
    }
    if (command?.isNotEmpty == true) {
      if (buffer.isNotEmpty) {
        scripts.add(buffer.toString());
      }
      result[command] = scripts;
    }
    return result;
  }
}