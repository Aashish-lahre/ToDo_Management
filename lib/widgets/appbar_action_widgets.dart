import 'package:flutter/material.dart';
import 'package:task_management/common/constants.dart';

List<Widget> getHomeScreenAppbarActionWidgets(BuildContext context) {
  double _width = 40;
  double _height = 40;
  return <Widget>[
    Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      child: Icon(
        Icons.notifications,
        color: Theme.of(context).iconTheme.color,
      ),
    ),
    SizedBox(
      width: 20,
    ),
    PopupMenuButton<int>(
      icon: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(
          Icons.more_vert,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
      onSelected: (int value) {
        print('selected : $value');
      },
      itemBuilder: (context) {
        return [
           PopupMenuItem<int>(
            value: 1,
            child: Text('Settings', style: Theme.of(context).textTheme.bodyMedium,),
          ),
           PopupMenuItem<int>(
            value: 2,
            child: Text('Select', style: Theme.of(context).textTheme.bodyMedium,),
          ),
           PopupMenuItem<int>(
            value: 3,
            child: Text('Sync', style: Theme.of(context).textTheme.bodyMedium,),
          ),
        ];
      },
    ),
  ];
}
