
import 'package:flutter/material.dart';

class NoteInputWidget extends StatelessWidget {
  const NoteInputWidget({
    super.key,
    required this.noteFocusNode,
    required this.noteController,
  });

  final FocusNode noteFocusNode;
  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.blueGrey,
        width: double.infinity,

        // height: 500,
        child:  TextField(
          focusNode: noteFocusNode,
          controller: noteController,
          expands: true,
          maxLines: null,
          // focusNode: _noteFocusNode,
          decoration:  InputDecoration(

            hintText: noteController.text.isEmpty ? "Note" : null,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

          ),
        ),
      ),
    );
  }
}


