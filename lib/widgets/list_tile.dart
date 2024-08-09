import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  VoidCallback callback;
  final String title;
  final String subtitle;
  final String time;
  Color customColor;

   ListTileWidget({
     required this.callback,
     required this.title,
     required this.subtitle,
     required this.time,
     super.key,
     this.customColor = Colors.black45
   });

   String get subtitleAndTime {
     if(subtitle.isNotEmpty) {
       return "$subtitle \n $time";
     } else {
       return " \n $time";
     }
   }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      tileColor: customColor,
      title: Text(title.isNotEmpty ? title : " "),
      subtitle: Text(subtitleAndTime),
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Set the border radius here
        side: const BorderSide(color: Colors.black, width: 1), // Optional: Add a border color and width
      ),

    );
  }
}
