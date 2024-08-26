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
          // style: Theme.of(context).textTheme.bodyMedium,
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
    return Container(
      decoration: BoxDecoration(
        color: customColor,
        borderRadius: BorderRadius.circular(18),
        // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.surface.withOpacity(.1),
        //     offset: Offset(-4, 4),
        //   ),
        // ],
      ),

      child: ListTile(
        onTap: callback,
        title: title.isNotEmpty ? Text(title) : null,
        subtitle: subtitleAndTime(context),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),

      ),
    );


  }
}
