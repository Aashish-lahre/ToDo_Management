import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/widgets/note_input_widget.dart';
import 'package:task_management/widgets/title_input_widget.dart';

import '../widgets/EditingNavigationButtons.dart';
import '../widgets/navigationBarButtons.dart';

class NoteDetailScreen extends StatefulWidget {
  final int noteIndex;


  const NoteDetailScreen(this.noteIndex, {super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final FocusNode noteFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  late TextEditingController titleController;
  late TextEditingController noteController;
  Color navBg = Colors.lightGreen;
  // late List<NoteModel> notes;
  late NoteModel note;
  late NotesProvider noteProvider;

  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isEditingTitle = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isBookmark =  ValueNotifier<bool>(false);


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

  void submitNote() {

    NoteModel newNote = NoteModel(
        title: titleController.text,
        note: noteController.text,
        bookmarked: note.bookmarked);
    context.read<NotesProvider>().editNote(note, newNote);
    isEditing.value = false;
    isEditingTitle.value = false;
    titleFocusNode.unfocus();
    noteFocusNode.unfocus();
  }


  @override
  void initState() {
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);

    titleFocusNode.addListener(() {
      if (titleFocusNode.hasFocus) {
        isEditing.value = true;
        isEditingTitle.value = true;
      }
    });

    noteFocusNode.addListener(() {
      if (noteFocusNode.hasFocus) {
        isEditing.value = true;
        isEditingTitle.value = false;
      }
    });
    noteProvider = context.read<NotesProvider>();
    isBookmark.value = noteProvider.notes[widget.noteIndex].bookmarked;
    noteProvider.addListener(() {
      // print('entered add listener');
      // if(noteProvider.notes_length > widget.noteIndex) {
      //   print('notes length is more the index');
      //   // Navigator.of(context).pop();
      //   try{
      //
      //   } on RangeError {
      //     print('error caught here in add listener');
      //   }
      // }
      //

      if(noteProvider.notes.elementAtOrNull(widget.noteIndex) != null) {
        note = noteProvider.notes[widget.noteIndex];
        isBookmark.value = note.bookmarked;

      }


    });



    note = noteProvider.notes[widget.noteIndex];
    titleController.text = note.title;
    noteController.text = note.note;
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    String formattedTime =
        DateFormat('EEEE, MMMM d, hh:mm a').format(note.time);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (checkForValidNote()) {
          // &&  (titleFocusNode.hasFocus || noteFocusNode.hasFocus)
          if(isEditing.value) {
            submitNote();
          }

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
        appBar: buildAppBar(context),
        body: Column(
          children: [
            TitleInputWidget(
                titleController: titleController,
                context: context,
                noteFocusNode: noteFocusNode,
                titleFocusNode: titleFocusNode,
                formattedTime: formattedTime),
            NoteInputWidget(
                noteFocusNode: noteFocusNode, noteController: noteController)
          ],
        ),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: isEditing,
              builder: (context, isEditingValue, child) {
                if (isEditingValue) {
                  return ValueListenableBuilder(
                    valueListenable: isEditingTitle,
                    builder: (context, isEditingTitleValue, child) {
                      if (isEditingTitleValue) {
                        return const SizedBox.shrink();
                      } else {
                        return const EditingNavigationButtons();
                      }
                    },
                  );
                } else {
                  return  NavigationBarButtons(thisNoteIndex: widget.noteIndex,);
                }
              },
              // child: buildNavigationBar(context),
            ),
      )),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 40,
        color: Theme.of(context).iconTheme.color,
      ),


      actions: [

        ValueListenableBuilder<bool>(
          valueListenable: isEditing,
          builder: (context, value, child) {
            return value
                ? ValueListenableBuilder<bool>(
                    valueListenable: isNoteValid,
                    builder: (context, value, child) {
                      return IconButton(
                        onPressed: value
                            ? () {
                          print('note is valid');
                                submitNote();

                              }
                            : null,
                        icon: Icon(
                          Icons.check,
                          color:
                              isNoteValid.value ? Colors.yellow : Colors.grey,
                        ),
                        iconSize: 50,
                      );
                    },
                  )
                : ValueListenableBuilder<bool>(
              valueListenable: isBookmark,
                  builder: (context, value, child) {
                print('bookmark called or value changed');
                return IconButton(
                  onPressed: () {
                    print('this should visible when pressed');
                    context
                        .read<NotesProvider>()
                        .editBookmark(note, !value);
                  },
                  icon: Icon(value
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined),
                  iconSize: 50,
                  color: Theme.of(context).iconTheme.color,
                );
                  },

                );
          },
        ),
      ],
    );
  }

  Padding buildNavigationBar(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                offset: const Offset(0, 20),
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
                        context.read<NotesProvider>().deleteNote(widget.noteIndex);
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
}
