import 'package:flutter/material.dart';

import 'dart:math';
import 'humidity_indicator_custom_painter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hitTestResult = false;
  double _position = 50;

  Offset _center;
  double _radius;
  double _height;

  void performCircleHitTest(Offset dragDown) {
    Offset panButtonCenter = _center;

    final leftSideValue = pow((dragDown.dx - panButtonCenter.dx), 2) +
        pow((dragDown.dy - panButtonCenter.dy), 2);
    if (leftSideValue <= pow(_radius, 2)) {
      _hitTestResult = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Function _callback = ({Offset center, double radius, double height}) {
      _center = center;
      _radius = radius;
      _height = height;
    };

    return Container(
      child: GestureDetector(
        onVerticalDragDown: (details) {
          performCircleHitTest(details.localPosition);
        },
        onVerticalDragUpdate: (details) {
          if (_hitTestResult) {
            setState(() {
              double verticalDelta =
                  (details.primaryDelta * (100.0 / _height) * 1);

              _position += verticalDelta;
              if (_position < 0.0) {
                _position = 0.0;
              } else if (_position > 100.0) {
                _position = 100.0;
              }
            });
          }
        },
        onVerticalDragEnd: (details) {
          _hitTestResult = false;
        },
        child: CustomPaint(
          painter: HumidityIndicatorCustomPainter(
              context: context, position: _position, callBack: _callback),
          size: Size.infinite,
        ),
      ),
    );
  }
}
