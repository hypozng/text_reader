import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:file_picker/file_picker.dart';

import 'package:text_reader/page.dart';
import 'package:text_reader/model.dart';
import 'package:text_reader/common.dart';
import 'package:text_reader/widgets.dart';

@ARoute(url: ARouterConfig.add_book)
class AddBookPage extends BasicPage {

  AddBookPage([Map<String, dynamic> params]) : super(params);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends BasicState<AddBookPage> {
  var _nameController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _urlController = TextEditingController();

  List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加书籍")
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              InputField(
                title: "名称",
                controller: _nameController
              ),
              InputField(
                title: "描述",
                controller: _descriptionController
              ),
              InputField(
                title: "地址",
                controller: _urlController
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text("添加"),
                onPressed: _save
              )
            ]
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.open_in_browser),
        onPressed: _openConfigFile
      )
    );
  }

  /// 添加
  void _save() async {
    if (_nameController.text.isEmpty) {
      showToast(context, "请输入书籍名称");
      return;
    }
    if (_urlController.text.isEmpty) {
      showToast(context, "请输入书籍url");
      return;
    }
    Book book = Book(
      name: _nameController.text,
      description: _descriptionController.text,
      url: _urlController.text
    );
    await DBHelper.save(book);
    for (var chapter in chapters) {
      chapter.bookId = book.id;
      await DBHelper.insert(chapter);
    }
  }

  /// 打开配置文件
  void _openConfigFile() async {
    var file = await FilePicker.getFile(fileExtension: "json");
    if (file == null) {
      return;
    }
    String jsonText = await file.readAsString();
    Map<String, dynamic> data = json.decode(jsonText);
    Book book = Book.fromJson(data);
    print(book.chapters?.length);
    _nameController.text = book.name;
    _descriptionController.text = book.description;
    _urlController.text = book.url;
    setState(() => null);
    chapters = data["chapters"].map<Chapter>((data) => Chapter.fromJson(data)).toList();

  }
}