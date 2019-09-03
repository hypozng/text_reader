import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

  var chapter = Chapter();

  int playIndex = 0;

  bool playing = false;

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params["book"]?.name ?? "电子书")
      ),
      body: Container(
        child: MyListView<String>(
          data: chapter?.paragraphs,
          itemBuilder: _renderItem,
          onRefresh: _refresh,
          controller: controller
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(playing ? Icons.stop : Icons.play_arrow),
        backgroundColor: Colors.black12,
        onPressed: () {
          if (playing) {
            _stop();
          } else {
            --playIndex;
            _play();
          }
        }
      ),
    );
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  Widget _renderItem(BuildContext context, int index, String paragraph) {
    return Container(
      color: playIndex == index ? Colors.amber : null,
      child: ListTile(
        title: Text(
          paragraph,
          style: TextStyle(
            fontSize: 18,
          )
        ),
        onTap: () {
          playIndex = index - 1;
          _play();
        },
      )
    );
  }

  /// 开始播放语音
  void _play() {
    playing = true;
    ++playIndex;
    if (playIndex >= chapter.paragraphs.length) {
      _stop();
      return;
    }
    // controller.jumpTo(controller.);
    setState(() {});
    // controller.attach(ScrollPosition())
    // print(controller.position);
    // controller.position.moveTo(playIndex.toDouble());
    var paragraph = chapter.paragraphs[playIndex];
    TtsHelper.speak(paragraph).then((_) {
      if (playing) {
        _play();
      }
    });
  }

  /// 停止播放语音
  void _stop() {
    setState(() => playing = false);
    TtsHelper.stop();
  }

  /// 加载小说资源
  Future<void> _refresh() async {
    var result = await dio.get(book.url);
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
    List<String> list = text.split("<br/>");
    list.removeWhere((s) => s == null || s.trim().isEmpty);
    setState(() => chapter.paragraphs = list);
  }
}