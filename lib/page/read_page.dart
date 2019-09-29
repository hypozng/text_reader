import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';

import 'package:text_reader/common.dart';
import 'package:text_reader/model.dart';
import 'package:text_reader/page.dart';
import 'package:text_reader/widgets.dart';

/// 阅读页面
@ARoute(url: ARouterConfig.read)
class ReadPage extends BasicPage {

  ReadPage([Map<String, dynamic> params]) : super(params);

  @override
  _ReadPageState createState() => _ReadPageState();

}

class _ReadPageState extends State<ReadPage> {

  var _pattern = '<div id="content">';

  final _title_reg = RegExp(r"第\d+章*");

  final _chapterno_reg = RegExp(r"\d+");

  final _replaces = <Pattern, String> {
    "&nbsp;": "",
    RegExp(r"\*"): "星",
    RegExp(r"[xX]"): "叉",
  };

  Book get book => widget?.params["book"];

  Chapter chapter;

  int playIndex = 0;

  bool playing = false;

  bool loading = false;

  GlobalKey key = GlobalKey();

  ScrollController controller = ScrollController();

  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params["book"]?.name ?? "电子书"),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () async {
              var result = await toPage(context, ARouterConfig.catelog, params: {"book": book});
              if (result == null) {
                return;
              }
              await _refresh();
              _play(0);
            }
          )
        ]
      ),
      body: Stack(
        children: <Widget> [
          Container(
            child: Column(
              children: <Widget> [
                _chapterBar(),
                Expanded(
                  child: MyListView<String>(
                    data: chapter?.paragraphs,
                    itemBuilder: _renderItem,
                    // onRefresh: _refresh,
                    controller: controller
                  )
                )
              ]..removeWhere((e) => e == null)
            )
          ),
          loading ? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54,
            alignment: Alignment.center,
            child: CircularProgressIndicator()
          ) : null
        ]..removeWhere((e) => e == null)
      )
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    playing = false;
    TtsHelper.stop();
  }

  /// 章节
  Widget _chapterBar() {
    if (chapter == null) {
      return null;
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 3)]
      ),
      child: Row(
        children: <Widget> [
          Expanded(
            child: ListTile(
              title: Text("第${chapter.number}章 ${chapter.title}")
            )
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refresh
          ),
          IconButton(
            icon: Icon(playing ? Icons.stop : Icons.play_arrow),
            onPressed: playing ? _stop : _play
          )
        ]
      )
    );
  }

  Widget _renderItem(BuildContext context, int index, String paragraph) {
    return Container(
      key: index == playIndex ? key : null,
      color: playIndex == index ? ThemeData.light().textSelectionColor : null,
      child: ListTile(
        title: Text(
          paragraph,
          style: TextStyle(
            fontSize: 18,
          )
        ),
        onTap: () => _play(index)
      )
    );
  }

  /// 开始播放语音
  void _play([int index]) {
    if (chapter == null) {
      return;
    }
    playIndex = index ?? 0;
    playing = true;
    scrollOffset = playIndex > 0
      ? scrollOffset + key.currentContext?.size?.height ?? 0 : 0;
    controller.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut
    );
    setState(() {});
    _speak(chapter.paragraphs[playIndex]);
  }

  void _speak(String text) async {
    await TtsHelper.speak(text);
      if (!playing) {
        return;
      }
      ++playIndex;
      if (playIndex >= chapter.paragraphs.length) {
        ++book.chapterNumber;
        await _refresh();
        _play(0);
        return;
      }
      _play();
  }

  /// 停止播放语音
  Future<void> _stop() async {
    if (mounted) {
      setState(() => playing = false);
    }
    await TtsHelper.stop();
  }

  /// 加载小说资源
  Future<void> _refresh() async {
    setState(() => loading = true);
    var chapters = await DBHelper.find(Chapter(
      bookId: book.id,
      number: book.chapterNumber
    ), (data) => Chapter.fromJson(data));
    if (chapters.isEmpty) {
      return;
    }
    chapter = chapters[0];
    var url = "${book.url}${chapter.uri}";
    print("===> $book  第${chapter.number}章 ${chapter.title}");
    print("===> $url");
    var result = await dio.get(url);
    String html = result.data;
    var start = html.indexOf(_pattern);
    if (start != null) {
      start += _pattern.length;
    }
    var end = html.indexOf(RegExp(r"<script.*>"), start);
    print("start=$start, end=$end");
    if (start == -1 || end == -1) {
      return;
    }
    var text = html.substring(start, end);
    _replaces.forEach((r, p) {
      text = text.replaceAll(r, p);
    });
    chapter.paragraphs = text.split("<br/>")
      ..removeWhere((s) => s == null || s.trim().isEmpty || s.contains(chapter.title));
    setState(() => loading = false);
    DBHelper.save(book);
  }
}