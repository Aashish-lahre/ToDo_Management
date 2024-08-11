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
  late NotesProvider notesProvider;
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(true);
  late TextEditingController titleController;
  late TextEditingController noteController;
  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(false);
   int thisNoteIndex = -1;

  Color nav_bg = Colors.lime;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);
    notesProvider = context.read<NotesProvider>();
    notesProvider.addListener(() {
      // if(notesProvider.notes_length < 1) {
      //   Navigator.of(context).pop();
      // }
    });
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        isEditing.value = true;
      }
    });

    _noteFocusNode.addListener(() {
      if (_noteFocusNode.hasFocus) {
        isEditing.value = true;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    _titleFocusNode.dispose();
    titleController
      ..removeListener(checkForValidNote)
      ..dispose();
    noteController
      ..removeListener(checkForValidNote)
      ..dispose();

    super.dispose();
  }

  bool checkForValidNote() {
    if (titleController.text.trim().isNotEmpty ||
        noteController.text.trim().isNotEmpty) {
      isNoteValid.value = true;
      return true;
    } else {
      isNoteValid.value = false;
      return false;
    }
  }

  void createNote() {
    NoteModel note = NoteModel(
        title: titleController.text,
        note: noteController.text,
        bookmarked: false);
    context.read<NotesProvider>().addNote(note);
  }

  void editBookmark(NoteModel note, bool flag) {
    print('flag : $flag');
    // NoteModel note = NoteModel(
    //     title: titleController.text,
    //     note: noteController.text,
    //     bookmarked: !flag);
    context.read<NotesProvider>().editBookmark(note, flag);
  }


  void submitNote(int index) {

    if(index != -1) {
      print('editing now...');
      NoteModel fetchNote = context.read<NotesProvider>().notes[index];
      NoteModel newNote = NoteModel(
          title: titleController.text,
          note: noteController.text,
          bookmarked: fetchNote.bookmarked);

      context.read<NotesProvider>().editNote(fetchNote, newNote);
    } else {
       NoteModel newNote = NoteModel(
          title: titleController.text,
          note: noteController.text,
          bookmarked: false);

      thisNoteIndex = context.read<NotesProvider>().addNoteReturnIndex(newNote);



    }




    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NoteDetailScreen(index - 1)));
    isEditing.value = false;
    _titleFocusNode.unfocus();
    _noteFocusNode.unfocus();
    setState(() {
      // isEditing = false;
      thisNoteIndex = thisNoteIndex;

      // print('index is : $thisNoteIndex');
    });
  }



  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat('EEEE, MMMM d, hh:mm a').format(DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (checkForValidNote()) {
          if(isEditing.value) {
            createNote();
          }

          titleController.clear();
          noteController.clear();
        }
        print('calling pop...');
        // Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('checking can pop...');
          if (Navigator.of(context).canPop()) {
            print('allowed');
            Navigator.of(context).pop();
          }
          print('not allowed');
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
                height: MediaQuery.of(context).size.height -
                    buildAppBar(context).toolbarHeight!,
                child: Column(
                  children: [
                    // Title input
                    TitleInputWidget(
                        titleController: titleController,
                        context: context,
                        noteFocusNode: _noteFocusNode,
                        titleFocusNode: _titleFocusNode,
                        formattedTime: formattedTime),

                    // Note input
                    NoteInputWidget(
                        noteFocusNode: _noteFocusNode,
                        noteController: noteController),
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
        margin: EdgeInsets.all(10),
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
        child: ValueListenableBuilder(
        valueListenable: isEditing,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!value)
                IconButton(
                    onPressed: () {
                      print('this note index : $thisNoteIndex');
                      context.read<NotesProvider>().deleteNote(thisNoteIndex);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete)),
            ],
          );
        },
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
        ValueListenableBuilder(valueListenable: isEditing,

            builder: (context, value, child) {
          return value ? ValueListenableBuilder<bool>(
            valueListenable: isNoteValid,
            builder: (context, value, child) {
              return IconButton(
                onPressed: isNoteValid.value ? () {
                  print('submitting note at index: $thisNoteIndex');
                  submitNote(thisNoteIndex);
                } : null,
                icon: Icon(
                  Icons.check,
                  color: isNoteValid.value ? Colors.yellow : Colors.grey,
                ),
                iconSize: 50,
              );
            },
          ) : Consumer<NotesProvider>(builder: (_, noteProvider, child) {
            late NoteModel? note;
            try {

            note = noteProvider.notes.elementAt(thisNoteIndex);
            } on RangeError {
              note = null;
            }

            // print('is bookmarked : ${note.bookmarked}');
            return
              IconButton(
                onPressed: () {
                  print('press reached');
                  editBookmark(note!, !note.bookmarked);
                },
                icon: Icon(note != null ? note.bookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border_outlined : Icons.bookmark_border_outlined),
                iconSize: 50,
              );

          });
            }),



      ],
    );
  }
}
