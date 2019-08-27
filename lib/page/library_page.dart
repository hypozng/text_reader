import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:annotation_route/route.dart';
import 'dart:io';

import 'package:text_reader/model.dart';
import 'package:text_reader/page.dart';
import 'package:text_reader/common.dart';

@ARoute(url: ARouterConfig.library)
class LibraryPage extends BasicPage {

  LibraryPage([Map<String, dynamic> params]) : super(params);

  @override
  _LibraryPageState createState() => _LibraryPageState();
} 

class _LibraryPageState extends State<LibraryPage> {

  List<Book> books = [
    Book(name: "校花的贴身高手"),
    Book(name: "最佳女婿"),
    Book(name: "很纯很暧昧"),
    Book(name: "重生追美记"),
    Book(name: "天降巨幅"),
    Book(name: "麻衣神算子"),
  ];

  @override
  Widget build(BuildContext context) {
    (() async {

      var bundle = rootBundle ?? NetworkAssetBundle(Uri.directory(Uri.base.origin));
      var result = await bundle.loadString(DBHelper.init_key);
      var lines = result.split(RegExp(r"\n"));
      var cmdreg = RegExp(r"==== .+ ====");
      var cmds = Map<String, List<String>>();
      var cmd = "", sqls = <String>[], sqlbuf = StringBuffer();
      var begin = false;
      for(var line in lines) {
        // if (cmdreg.hasMatch(line)) {
        //   if (sqlbuf.isNotEmpty) {
        //     sqls.add(sqlbuf.toString());
        //   }
        //   if (cmd?.isNotEmpty == true) {
        //     cmds[cmd] = sqls ?? <String>[];
        //   }
        //   cmd = line.substring(5, line.length - 6);
        //   sqls = <String>[];
        //   sqlbuf.clear();
        //   begin = false;
        //   continue;
        // }
        // print("line=$line${line.toLowerCase()}");
        StringBuffer bf = StringBuffer();
        bf.write(line);
        var text = bf.toString();
        print("line=$line $text");
        // if (line == "----") {
        //   if (sqlbuf?.isNotEmpty == true) {
        //     sqls.add(sqlbuf.toString());
        //   }
        //   sqlbuf.clear();
        //   begin = false;
        //   continue;
        // }
        // if (line?.isNotEmpty == true) {
        //   if (begin) {
        //     sqlbuf.write("\r\n");
        //   } else {
        //     begin = true;
        //   }
        //   sqlbuf.write(line);
        // }
      }
      if (sqlbuf?.isNotEmpty == true) {
        sqls.add(sqlbuf.toString());
      }
      cmds[cmd] = sqls;
      cmds.forEach((cmd, sqls) {
        print("command: $cmd");
        for (var i = 0; i < sqls.length; ++i) {
          print("${i + 1}: ${sqls[i]}");
        }
      });
    })();

    return Scaffold(
      appBar: AppBar(
        title: Text("书架"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: _renderItem
        )
      )
    );
  }

  Widget _renderItem(BuildContext context, int index){
    var book = books[index];
    return ListTile(
      title: Text(book.name),
      subtitle: book.description == null ? null : Text(book.description),
      onTap: () {
        toPage(context, ARouterConfig.read, params: {"book": book});
      }
    );
  }

  /// 加载本地收藏的图书列表
  void _loadBooks() {
    // AssetBundle bundle;
    // AssetBundle();
  }
}