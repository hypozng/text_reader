import 'package:flutter/material.dart';

import 'package:text_reader/common.dart' as common;

abstract class BasicPage extends StatefulWidget {
  final Map<String, dynamic> _params;

  BasicPage([Map<String, dynamic> params])
    : this._params = params ?? {};

  Map<String, dynamic> get params => _params;

}

abstract class BasicState<T extends BasicPage> extends State<T> {

  // void showToast(String message, [int duration, int gravity]) {
  //   common.showToast(context, message, duration, gravity);
  // }

  // Future<T> toPage<T>(String url, {
  //   Map<String, dynamic> routerParams,
  //   Map<String, dynamic> params
  // }) {
  //   return common.toPage(context, url,
  //     routerParams: routerParams,
  //     params: params
  //   );
  // }
}