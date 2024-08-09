import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/network/models/notes_model.dart';

class NoteDetailScreen extends StatefulWidget {
  final NoteModel note;
  const NoteDetailScreen(this.note, {super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {

  late TextEditingController  titleController;
  late TextEditingController noteController;

  @override
  void initState() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    titleController.text = widget.note.title;
    noteController.text = widget.note.note;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('EEEE, MMMM d, hh:mm a').format(widget.note.time);
    return SafeArea(child: Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          // Title input
          Container(
            color: Colors.cyan,
            width: double.infinity,
            height: 150,
            child:  Column(
              children: [
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 50),
                  decoration: const InputDecoration(

                    hintText: 'Title',
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
          ),


          // Note input
          Expanded(child: Container(
            child: TextField(
              controller: noteController,
              expands: true,
              maxLines: null,
              // focusNode: _noteFocusNode,
              decoration: const InputDecoration(

                hintText: 'Note',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,

              ),
            ),
          )),
        ],
      ),
    ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios_new),
        iconSize: 40,
      ),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.check),
          iconSize: 50,
        )
      ],
    );
  }
}
