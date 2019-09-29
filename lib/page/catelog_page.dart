import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  GlobalKey _itemKey;

  ScrollController _listScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? "目录")
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget> [
            Container(
              margin: EdgeInsets.all(3),
              child: TextField()
            ),
            Expanded(
              child: MyListView<Chapter>(
                controller: _listScroller,
                data: chapters,
                itemBuilder: _renderItem,
                onRefresh: _refresh
              )
            )
          ]
        )
      )
    );
  }

  Widget _renderItem(BuildContext context, int index, Chapter chapter) {
    return Slidable(
      key: _itemKey == null ? (_itemKey = GlobalKey()) : null,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.15,
      child: Container(
        color: chapter.number == book.chapterNumber
          ? ThemeData.light().textSelectionColor : Colors.white,
        child: ListTile(
          title: Text("第${chapter.number ?? ''}章 ${chapter.title}"),
          onTap: () {
            book?.chapterNumber = chapter.number;
            Navigator.pop(context, book);
          }
        )
      ),
      secondaryActions: <Widget> [
        IconSlideAction(
          color: Colors.redAccent,
          icon: Icons.delete,
        ),
        IconSlideAction(
          color: Colors.blueAccent,
          icon: Icons.edit
        )
      ]
    );
  }

  Future<void> _refresh() async {
    chapters = await DBHelper.find(Chapter(
      bookId: widget.params["book"]?.id
    ), (data) => Chapter.fromJson(data));
    setState(() => _itemKey = null);
    _scroll(book.chapterNumber);
  }

  /// 滚动到指定章节
  void _scroll(int chapterNumber) async {
    if (chapterNumber == null
      || chapterNumber < 1
      || chapterNumber > (chapters?.length ?? 0)) {
      return;
    }
    int count = 0;
    bool found = false;
    await Future.delayed(Duration(milliseconds: 200));
    double itemHeight = _itemKey?.currentContext?.size?.height ?? 0;
    if (itemHeight == 0) {
      return;
    }
    for (Chapter chapter in chapters) {
      if (chapter.number == chapterNumber) {
        found = true;
        break;
      }
      ++count;
    }
    if (!found) {
      return;
    }
    _listScroller.animateTo(count * itemHeight,
      duration: Duration(milliseconds: 10),
      curve: Curves.ease
    );
  }
}
