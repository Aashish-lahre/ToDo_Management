import 'package:flutter/material.dart';
import 'package:task_management/common/constants.dart';

List<Widget> getHomeScreenAppbarActionWidgets() {
  double _width = 60;
  double _height = 60;
  return <Widget>[
    Container(
      width: _width,
      height: _height,
      decoration:  BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10)

      ),
      child: const Icon(Icons.menu),
    ),
    SizedBox(width: 20,),
    Container(
      width: _width,
      height: _height,
      decoration:  BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(10)

      ),
      child: const Icon(Icons.people),
    ),
  ];
}
