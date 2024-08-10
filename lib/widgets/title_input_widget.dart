import 'package:flutter/material.dart';

class TitleInputWidget extends StatelessWidget {
  const TitleInputWidget({
    super.key,
    required this.titleController,
    required this.context,
    required this.noteFocusNode,
    required this.titleFocusNode,
    required this.formattedTime,
  });

  final TextEditingController titleController;
  final BuildContext context;
  final FocusNode noteFocusNode;
  final FocusNode titleFocusNode;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.cyan,
      width: double.infinity,
      height: 150,
      child:  Column(
        children: [
          TextField(
            controller: titleController,
            focusNode: titleFocusNode,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 50),
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(noteFocusNode);
            },
            decoration:  InputDecoration(

              hintText: titleController.text.isEmpty ? 'Title' : null,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,

            ),

          ),
          SizedBox(
            width: double.infinity,
            child: Text(formattedTime, style: const TextStyle(fontSize: 20),),
          ),
        ],
      ),
    );
  }
}