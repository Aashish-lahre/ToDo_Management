import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/utility/scaffold_message.dart';
import '../network/data/notes/notes_provider.dart';

class NavigationBarButtons extends StatelessWidget {
  final int thisNoteIndex;
  final Size screenSize;
  const NavigationBarButtons({required this.thisNoteIndex, required this.screenSize, super.key});



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery
          .of(context)
          .viewInsets,
      child: Container(
// margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.3),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            border:  Border(
              top: BorderSide(
                  color: Colors.grey[700]!, width: 1, style: BorderStyle.solid),
              left: BorderSide(
                  color: Colors.grey[700]!, width: 1, style: BorderStyle.solid),
              right: BorderSide(
                  color: Colors.grey[700]!, width: 1, style: BorderStyle.solid),


            )
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {
              scaffoldMessage(message: 'Share, Coming Soon...',context:  context,screenSize:  screenSize);
            }, icon: const Icon(Icons.share_rounded)),
            IconButton(onPressed: () {
              context.read<NotesProvider>().deleteNote(thisNoteIndex, context);
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.delete_rounded)),
            IconButton(onPressed: () {
              scaffoldMessage(message: 'Clock, Coming Soon...',context:  context,screenSize:  screenSize);
            }, icon: const Icon(Icons.timer_rounded)),
            IconButton(onPressed: () {
              scaffoldMessage(message: 'Themes, Coming Soon...',context:  context,screenSize:  screenSize);
            }, icon: const Icon(Icons.wallpaper_rounded)),

          ],
        ),
      ),
    );
  }
}




