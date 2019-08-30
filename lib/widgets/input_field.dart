import 'package:flutter/material.dart';

/// 输入框
class InputField extends StatefulWidget {
  /// 标题
  String title;

  /// 控制器
  TextEditingController controller;

  InputField({
    this.title,
    this.controller
  });

  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Column(
        children: <Widget> [
          Container(
            width: double.infinity,
            child: Text(widget.title),
          ),
          TextField(
            controller: widget.controller
          )
        ]
      )
    );
  }
}