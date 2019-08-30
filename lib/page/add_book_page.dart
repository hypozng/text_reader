import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';

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

class _AddBookPageState extends State<AddBookPage> {
  var _nameController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _urlController = TextEditingController();

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
      )
    );
  }

  /// 添加
  void _save() {
    Book book = Book(
      id: uuid(),
      name: _nameController.text,
      description: _descriptionController.text,
      url: _urlController.text
    );
    // print("name=${book.name}, desciption=${book.description}, url=${book.url}");
    print('book=${book.toJson()}');
  }
}