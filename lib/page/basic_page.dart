import 'package:flutter/material.dart';

abstract class BasicPage extends StatefulWidget {
  final Map<String, dynamic> _params;

  BasicPage([Map<String, dynamic> params])
    : this._params = params ?? {};

  Map<String, dynamic> get params => _params;

}