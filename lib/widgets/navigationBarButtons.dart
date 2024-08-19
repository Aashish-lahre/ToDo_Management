import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network/data/notes_provider.dart';

class NavigationBarButtons extends StatelessWidget {
  final int thisNoteIndex;
  const NavigationBarButtons({required this.thisNoteIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery
          .of(context)
          .viewInsets,
      child: Container(
// margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: const Border(
              top: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              left: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              right: BorderSide(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),


            )
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
            IconButton(onPressed: () {
              context.read<NotesProvider>().deleteNote(thisNoteIndex);
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.delete_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.timer_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.wallpaper_rounded)),

          ],
        ),
      ),
    );
  }
}




