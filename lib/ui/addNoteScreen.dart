import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/notes_model.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  final FocusNode _noteFocusNode = FocusNode();
  late TextEditingController titleController;
  late TextEditingController noteController;

  Color nav_bg = Colors.lime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    noteController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    titleController.dispose();
    noteController.dispose();

    super.dispose();
  }

  void checkForValidNote() {
    print('entered');
    if(titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
      // add the note
      NoteModel note = NoteModel(title: titleController.text, note: noteController.text, bookmarked: false);
      // Provider.of<NotesProvider>(context).addNote = note;
    }
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {


    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {
          // Add the note
          print('inside calculation');
          NoteModel note = NoteModel(title: titleController.text, note: noteController.text, bookmarked: false);
          context.read<NotesProvider>().addNote(note);
          titleController.clear();
          noteController.clear();
          // print('length : ${context.read<NotesProvider>().notes.length}');

          // Ensure the navigation happens after the note is added

        }
          print('outside');

            // Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });


    },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          appBar: buildAppBar(context),
          body: ListView(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - buildAppBar(context).toolbarHeight!,
                child: Column(
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
                            child: Text('Wednesday, August 7 | 03:02 PM', style: TextStyle(fontSize: 20),),
                          ),
                        ],
                      ),
                    ),

                    // Note input
                    Expanded(
                      child: Container(
                        color: Colors.blueGrey,
                        width: double.infinity,

                        // height: 500,
                        child:  TextField(
                          focusNode: _noteFocusNode,
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
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: buildNavigationBar(context),
          ),
      ),
    );
  }

  Padding buildNavigationBar(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          margin: EdgeInsets.all(10  ),

          decoration: BoxDecoration(
            color: nav_bg.withOpacity(0.8),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: nav_bg.withOpacity(0.3),
                  offset: Offset(0, 20),
                  blurRadius: 20),
            ],
          ),
          width: double.infinity,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              IconButton(onPressed: () {}, icon: Icon(Icons.add)),
              IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border_outlined)),


            ],
          ),
        ),
      );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 40,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: null,
        //     icon: Icon(Icons.check),
        //     iconSize: 50,
        //   )
        // ],
      );
  }


}


