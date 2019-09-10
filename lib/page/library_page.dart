import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';

import 'package:text_reader/model.dart';
import 'package:text_reader/page.dart';
import 'package:text_reader/common.dart';
import 'package:text_reader/widgets.dart';

@ARoute(url: ARouterConfig.library)
class LibraryPage extends BasicPage {

  LibraryPage([Map<String, dynamic> params]) : super(params);

  @override
  _LibraryPageState createState() => _LibraryPageState();
} 

class _LibraryPageState extends State<LibraryPage> {

  List<Book> books;

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
        child: MyListView(
          data: books,
          itemBuilder: _renderItem,
          onRefresh: _refresh
        )
      )
    );
  }

  Widget _renderItem(BuildContext context, int index, Book book){
    return ListTile(
      title: Text(book.name),
      subtitle: book.description == null ? null : Text(book.description),
      onTap: () {
        toPage(context, ARouterConfig.read, params: {"book": book});
      }
    );
  }

  /// 加载本地收藏的图书列表
  Future<void> _refresh() async {
    books = await DBHelper.getAll(Book, (data) => Book.fromJson(data));
    setState(() => null);
    // return Future.microtask(() {
    //   books = [
    //     Book(
    //       name: "校花的贴身高手",
    //       url: "https://www.biquge.tw/0_671/4356290.html"
    //     ),
    //     Book(name: "最佳女婿"),
    //     Book(name: "很纯很暧昧"),
    //     Book(name: "重生追美记"),
    //     Book(name: "天降巨幅"),
    //     Book(name: "麻衣神算子"),
    //   ];
    //   setState(() {});
    // });
  }
}