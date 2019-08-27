import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DBHelper {
  /// 数据库文件名
  static const String db_name = "text_reader.db";

  /// 初始化文件
  static const String init_key= "assets/database_init.txt";

  /// 数据库版本
  static const int version = 1;

  static String _databasesPath;

  /// 获取数据库存储路径
  static Future<String> getDatabasesPath() async {
    if (_databasesPath == null) {
      _databasesPath = await sqflite.getDatabasesPath();
    }
    return _databasesPath;
  }

  /// 打开数据库
  static Future<sqflite.Database> open() async {
    var dbpath = await getDatabasesPath();
    var dbfile = File("$dbpath/$db_name");
    if (!await dbfile.exists()) {
      await dbfile.create(recursive: true);
    }
    return await sqflite.openDatabase(
      dbfile.path,
      version: version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );
  }

  /// 创建数据库时调用
  static void _onCreate(sqflite.Database db, int version) {
    print("onCreate");
    // db.execute();
  }

  /// 更新数据库时调用
  static void _onUpgrade(sqflite.Database db, int oldVersion, int newVersion) {
    print("onUpgrade");
  }

  /// 当数据库版本下调时调用
  static void _onDowngrade(sqflite.Database db, int oldVersion, int newVersion) {
    print("onDowngrade");
  }

  static Future<Map<String, List<String>>> _readDatabases() async {
    var bundle = rootBundle ?? NetworkAssetBundle(Uri.directory(Uri.base.origin));
    var result = await bundle.loadString(init_key);
    var lines = result.split(RegExp(r"\n"));
    var cmdreg = RegExp(r"==== .+ ====");
    var cmd = "", sqls = [];
    lines.forEach((line) {
      if (cmdreg.hasMatch(line)) {
        print("command ${line.substring(5, line.length - 5)}");
      }
    });
  }
}