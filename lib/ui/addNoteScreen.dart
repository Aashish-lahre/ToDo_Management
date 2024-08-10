import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/notes_model.dart';
import 'package:task_management/ui/note_detail_screen.dart';

import '../widgets/note_input_widget.dart';
import '../widgets/title_input_widget.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();

  late TextEditingController titleController;
  late TextEditingController noteController;
  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(false);

  Color nav_bg = Colors.lime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    titleController..removeListener(checkForValidNote)..dispose();
    noteController..removeListener(checkForValidNote)..dispose();

    super.dispose();
  }

  bool checkForValidNote() {
    if(titleController.text.trim().isNotEmpty || noteController.text.trim().isNotEmpty) {

      isNoteValid.value = true;
      return true;
    } else {
      isNoteValid.value = false;
      return false;
    }
  }

  void createNote() {
    NoteModel note = NoteModel(title: titleController.text, note: noteController.text, bookmarked: false);
    context.read<NotesProvider>().addNote(note);
  }

  void submitNote() {
    NoteModel note = NoteModel(title: titleController.text, note: noteController.text, bookmarked: false);
    int index = context.read<NotesProvider>().addNoteReturnlength(note);

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NoteDetailScreen(index - 1)));

  }


  @override
  Widget build(BuildContext context) {

    String formattedTime = DateFormat('EEEE, MMMM d, hh:mm a').format(DateTime.now());



    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (checkForValidNote()) {


          createNote();
          titleController.clear();
          noteController.clear();

        }

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
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - buildAppBar(context).toolbarHeight!,
                child: Column(
                  children: [

                    // Title input
                    TitleInputWidget(titleController: titleController, context: context, noteFocusNode: _noteFocusNode, titleFocusNode: _titleFocusNode, formattedTime: formattedTime),

                    // Note input
                    NoteInputWidget(noteFocusNode: _noteFocusNode, noteController: noteController),
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
              // IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              // IconButton(onPressed: () {}, icon: Icon(Icons.add)),
              // IconButton(onPressed: () {}, icon: Icon(Icons.share)),
              // IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border_outlined)),


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
        actions: [

          ValueListenableBuilder<bool>(
            valueListenable: isNoteValid,
            builder: (context, value, child) {
              return IconButton(
                onPressed: isNoteValid.value ? submitNote : null,
                icon: Icon(Icons.check, color: isNoteValid.value ? Colors.yellow : Colors.grey,),
                iconSize: 50,
              );
            },

          )
        ],
      );
  }


}


