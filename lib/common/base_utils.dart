import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:toast/toast.dart';

import 'package:text_reader/common.dart';

/// 跳转到指定页面
Future<T> toPage<T>(
  BuildContext context,
  String url, {
    Map<String, dynamic> routerParams,
    Map<String, dynamic> params
  }) {
  var option = ARouteOption(url, routerParams);
  return Navigator.push<T>(context, MaterialPageRoute<T>(
    builder: (context) => ARouter.findPage(option, params)
  ));
}

/// 打开新页面，替换当前页面
Future<T> replacePage<T extends Object, TO extends Object>(
  BuildContext context,
  String url, {
    Map<String, dynamic> routerParams,
    Map<String, dynamic> params
  }
) {
  var option = ARouteOption(url, routerParams);
  return Navigator.pushReplacement<T, TO>(context, MaterialPageRoute<T>(
    builder: (context) => ARouter.findPage(option, params)
  ));
}

/// 生成UUID
String uuid() => Uuid().v1().replaceAll("-", "");

Dio dio = Dio();

void showToast(BuildContext context, [
  String message,
  int duration = 1,
  int gravity = 0
]) {
  Toast.show(message, context,
    duration: duration,
    gravity: gravity
  );
}

List<String> _unit1 = const ["", "十", "百", "千"];
List<String> _unit2 = const ["", "万", "亿"];
List<String> _nums = const ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
final int _u1l = _unit1.length;
final int _u2l = _unit2.length;

/// 计算基数乘以十的N次方
/// = base * 10 ^ power
int e(int base, int power) {
  int number = 1;
  for (int i = 0; i < power; ++i) {
    number *= 10;
  }
  return base * number;
}

/// 获取数字的长度/位数
int numlen(int number) {
  int d = 0;
  number = number.abs();
  while (number > 0) {
    ++d;
    number ~/= 10;
  }
  return d;
}

/// 将数字转换为中文发音的汉字
String num2zh(int number) {
  StringBuffer text = StringBuffer();
  if (number < 0) {
    text.write("负");
    number = number.abs();
  }
  int len = numlen(number);
  bool zero = false;
  for (var i = len - 1; i >= 0; --i) {
    var n = number ~/ e(1, i) % 10;
    var u1i = i % _u1l;
    var u2i = i ~/ _u1l % _u2l;
    if (n == 0) {
      zero = true;
      if (u1i == 0) {
        text.write(_unit2[u2i]);
      }
      continue;
    } else if (zero) {
      zero = false;
      text.write(_nums[0]);
    }
    text.write(_nums[n]);
    text.write(_unit1[u1i]);
    if (u1i == 0) {
      text.write(_unit2[u2i]);
    }
  }
  return text.toString();
}