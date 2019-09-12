import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';

import 'package:text_reader/page.dart';
import 'package:text_reader/common.dart';
import 'package:text_reader/model.dart';
import 'package:text_reader/widgets.dart';

@ARoute(url: ARouterConfig.catelog)
class CatelogPage extends BasicPage {

  CatelogPage([Map<String, dynamic> params]) : super(params);

  @override
  _CatelogPageState createState() => _CatelogPageState();
}

class _CatelogPageState extends State<CatelogPage> {
  List<Chapter> chapters;

  Book get book => widget.params["book"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? "目录")
      ),
      body: Container(
        child: MyListView<Chapter>(
          data: chapters,
          itemBuilder: _renderItem,
          onRefresh: _refresh
        )
      )
    );
  }

  Widget _renderItem(BuildContext context, int index, Chapter chapter) {
    return Container(
      color: chapter.number == book.chapterNumber
        ? ThemeData.light().textSelectionColor : Colors.transparent,
      child: ListTile(
        title: Text("第${chapter.number ?? ''}章 ${chapter.title}"),
        onTap: () {
          book?.chapterNumber = chapter.number;
          Navigator.pop(context);
        }
      )
    );
  }

  Future<void> _refresh() async {
    chapters = await DBHelper.find(Chapter(
      bookId: widget.params["book"]?.id
    ), (data) => Chapter.fromJson(data));
    setState(() => null);
  }
}
