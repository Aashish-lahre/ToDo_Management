import 'package:flutter/material.dart';
import 'package:task_management/common/utility/scaffold_message.dart';


class EditingNavigationButtons extends StatelessWidget {
  final Size screenSize;
  const EditingNavigationButtons({required this.screenSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery
          .of(context)
          .viewInsets,
      child: Container(
// margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.transparent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
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
            IconButton(onPressed: () {
              scaffoldMessage(message: 'Text Formatting, Coming Soon...',context:  context,screenSize:  screenSize);
            }, icon: const Icon(Icons.format_bold_rounded)),
            IconButton(onPressed: () {
              scaffoldMessage(message: 'Check Box, Coming Soon...',context:  context,screenSize:  screenSize);
            }, icon: const Icon(Icons.check_circle)),
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





