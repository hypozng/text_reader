import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';

import 'arouter.internal.dart';

@ARouteRoot()
class ARouter {
  static ARouterInternal internal = ARouterInternalImpl();

  static Widget findPage(ARouteOption option, [Map<String, dynamic> params]) {
    ARouterResult result = internal.findPage(option, params);
    if (result.state == ARouterResultState.FOUND) {
      return result.widget;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("page not found")
      ),
      body: Center(
        child: Text("page not found\r\n${option.urlpattern}")
      )
    );
  }
}