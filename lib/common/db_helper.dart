import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:text_reader/model.dart';

class DBHelper {
  /// 数据库文件名
  static const String db_name = "text_reader.db";

  /// 初始化文件
  static const String init_key= "assets/database_init.txt";

  /// 数据库版本
  static const int version = 1;

  static const _types = const<Type, String> {
    Book: "book"
  };

  static String _databasesPath;

  static sqflite.Database _database;

  /// 获取数据库存储路径
  static Future<String> get databasesPath async {
    return _databasesPath ??= await sqflite.getDatabasesPath();
  }

  static Future<sqflite.Database> get database async {
    return _database ??= await _open();
  }

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

  static Future<bool> save(dynamic model) async {
    if (model == null) {
      return false;
    }
    Type type = model.runtimeType;
    String table = _types[type];
    if (table == null) {
      return false;
    }
    Map<String, dynamic> json = model.toJson();
    String id = json["id"];
    var sql = StringBuffer();
    var begin = false;
    var result = await rawQuery("select count(1) as count from $table where id=?", [id]);
    if (result[0]["count"] == 0) {
      sql.write("insert into $table(");
      var values = StringBuffer();
      var arguments = List<dynamic>();
      begin = false;
      json.forEach((key, value) {
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
      sql.write(") values(${values.toString()})");
      return await rawUpdate(sql.toString(), arguments) > 0;
    }
    /// TODO 新增sql生成部分待完成
  }

  /// 打开数据库
  static Future<sqflite.Database> _open() async {
    var dbpath = await databasesPath;
    var dbfile = File("$dbpath/$db_name");
    if (!await dbfile.exists()) {
      await dbfile.create(recursive: true);
    }
    return await sqflite.openDatabase(
      dbfile.path,
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// 创建数据库时调用
  static void _onCreate(sqflite.Database db, int version) async {
    var result = await _load();
    result["init"].forEach((sql) {
      print("===> execute sql:\r\n$sql");
      db.execute(sql);
    });
    for (var i = 1; i <= version; ++i) {
      result["version $i"].forEach((sql) {
        print("===> execute sql:\r\n$sql");
        db.execute(sql);
      });
    }
  }

  /// 更新数据库时调用
  static void _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) async {
    var result = await _load();
    for (var i = oldVersion + 1; i <= newVersion; ++i) {
      result["version $i"].forEach((sql) {
        print("===> execute sql: $sql");
        db.execute(sql);
      });
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