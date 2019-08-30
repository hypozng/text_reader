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
    return Scaffold(
      appBar: AppBar(
        title: Text("书架"),
        centerTitle: true,
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => toPage(context, ARouterConfig.add_book)
          )
        ]
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