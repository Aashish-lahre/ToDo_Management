import 'package:flutter/material.dart';
import 'package:task_management/common/utility/scaffold_message.dart';

import 'package:task_management/ui/settings/settings_screen.dart';

List<Widget> getHomeScreenAppbarActionWidgets(BuildContext context) {
  Size screenSize = MediaQuery.of(context).size;
  double _width = 40;
  double _height = 40;
  Color containerColor = Theme.of(context).colorScheme.surface;
  return <Widget>[
    Container(

      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: containerColor,
          borderRadius: BorderRadius.circular(10)),
      child:  IconButton(
        onPressed: () => scaffoldMessage(message: 'Feature coming soon...',context: context ,screenSize:  screenSize),
        icon: Icon(Icons.notifications),

      ),
    ),
    const SizedBox(
      width: 20,
    ),
    PopupMenuButton<int>(
      icon: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10)),
        child: const Icon(
          Icons.more_vert,

        ),
      ),
      onSelected: (int value) => onClick(value, context, screenSize),
      itemBuilder: (context) {
        return [
           const PopupMenuItem<int>(
            value: 1,
            child: Text('Settings',
              // style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
           const PopupMenuItem<int>(
            value: 2,
            child: Text('Select',
              // style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
           const PopupMenuItem<int>(
            value: 3,
            child: Text('Sync',
              // style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ];
      },
    ),
  ];
}

void onClick(int value, BuildContext context, Size screenSize) {
  if(value == 1) Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
  if(value == 2) scaffoldMessage(message: 'Feature coming soon...', context: context, screenSize: screenSize);
  if(value == 3) scaffoldMessage(message: 'Feature coming soon...', context: context, screenSize: screenSize);

}