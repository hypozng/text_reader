import 'package:flutter/material.dart';
import 'package:annotation_route/route.dart';

import 'package:text_reader/common.dart';
import 'package:text_reader/page.dart';

@ARoute(url: ARouterConfig.splash_screen)
class SplashScreen extends BasicPage {

  SplashScreen([Map<String, dynamic> params]) : super(params);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String message = "";

  @override
  void initState() {
    super.initState();
    _init().then((_) => replacePage(context, ARouterConfig.library));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message
        )
      )
    );
  }

  Future _init() async {
    setState(() => message = "正在加载语音播放插件");
    await TtsHelper.init();
  }
}

