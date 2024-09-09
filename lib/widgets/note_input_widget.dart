
import 'package:flutter/material.dart';

class NoteInputWidget extends StatelessWidget {
  const NoteInputWidget({
    super.key,
    required this.noteFocusNode,
    required this.noteController,
    required this.haveBody,
  });

  final FocusNode noteFocusNode;
  final TextEditingController noteController;
  final bool haveBody;


  @override
  Widget build(BuildContext context) {
    return TextField(
      // scrollPhysics: NeverScrollableScrollPhysics(),
      cursorColor: Theme.of(context).colorScheme.onSurface, // Set the cursor color to a visible color
      cursorWidth: 2.0, // Adjust the cursor width if needed
      cursorRadius: Radius.circular(2.0), // Make the cursor slightly rounded
      focusNode: noteFocusNode,
      controller: noteController,
      expands: true,
      maxLines: null,
      style: Theme.of(context).textTheme.titleMedium,
      decoration:  InputDecoration(

        hintText: haveBody ? "have body" : 'no body',
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

      ),
    );
  }
}


