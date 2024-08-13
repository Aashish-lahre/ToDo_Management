import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTileWidget extends StatelessWidget {
  VoidCallback callback;
  final String title;
  final String subtitle;
  final String time;
  final Color customColor;


   ListTileWidget({
     required this.callback,
     required this.title,
     required this.subtitle,
     required this.time,
     super.key,
     required this.customColor,

   });

  Widget  subtitleAndTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.isEmpty ? " " : subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1, // Adjust maxLines as needed
        ),
        const SizedBox(height: 2), // Adds some spacing between subtitle and time
        Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: callback,
      tileColor: customColor,
      title: title.isNotEmpty ? Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(overflow: TextOverflow.ellipsis)) : null,
      subtitle: subtitleAndTime(context),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Set the border radius here
        side: const BorderSide(color: Colors.black, width: 1), // Optional: Add a border color and width
      ),

    );
  }
}
