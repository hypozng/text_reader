import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:annotation_route/route.dart';

import 'package:text_reader/common.dart';
import 'package:text_reader/model.dart';
import 'package:text_reader/page.dart';

/// 阅读页面
@ARoute(url: ARouterConfig.read)
class ReadPage extends BasicPage {

  ReadPage([Map<String, dynamic> params]) : super(params);

  @override
  _ReadPageState createState() => _ReadPageState();

}

class _ReadPageState extends State<ReadPage> {
  var _dio = Dio();

  var _pattern = '<div id="content">';

  final _title_reg = RegExp(r"第\d+章*");

  final _chapterno_reg = RegExp(r"\d+");

  final _replaces = <Pattern, String> {
    "&nbsp;": "",
    RegExp(r"\*"): "星",
    RegExp(r"[xX]"): "叉",
  };

  var chapter = Chapter();

  int playIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("电子书")
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            Row(
              children: <Widget> [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _load
                ),
                IconButton(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: _play
                )
              ]
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chapter.paragraphs.length,
                itemBuilder: (content, index) {
                  var paragraph = chapter.paragraphs[index];
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
                        playIndex = index;
                        _play();
                      },
                    )
                  );
                }
              )
            )            
          ]
        )
      )
    );
  }

  void _play() {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setCompletionHandler(() {
      print("end");
    });
    flutterTts.setSpeechRate(2);
    flutterTts.setPitch(1);
    flutterTts.speak(chapter.paragraphs[playIndex]);
  }

  void _load() async {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              CircularProgressIndicator()
            ]
          )
        );
      }
    );
    var result = await _dio.get("http://www.biquge.tw/0_671/363983.html");
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
    Navigator.pop(context);
  }
}