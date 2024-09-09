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

    return Column(
      children: [
        TextField(
          cursorColor: Theme.of(context).colorScheme.secondary, // Set the cursor color to a visible color
          cursorWidth: 2.0, // Adjust the cursor width if needed
          cursorRadius: const Radius.circular(2.0), // Make the cursor slightly rounded
          maxLength: 50,
          controller: titleController,
          focusNode: titleFocusNode,
          textInputAction: TextInputAction.next,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize:25),
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(noteFocusNode);
          },
          maxLines: null,
          decoration:  InputDecoration(
            counterText: '',
            hintText: titleController.text.isEmpty ? 'Title' : null,
            hintStyle: Theme.of(context).textTheme.titleLarge,

            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

          ),

        ),
        SizedBox(
          width: double.infinity,
          child: Text(formattedTime, style: const TextStyle(fontSize: 16),),
        ),
      ],
    );
  }
}