import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/widgets/editing_navigation_buttons.dart';
import 'package:task_management/widgets/navigation_bar_buttons.dart';

import '../widgets/note_input_widget.dart';
import '../widgets/title_input_widget.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> with WidgetsBindingObserver {
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  late NotesProvider notesProvider;
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isEditingTitle = ValueNotifier<bool>(false);
  late TextEditingController titleController;
  late TextEditingController noteController;
  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(false);
  int thisNoteIndex = -1;



  @override
  void initState() {
    super.initState();
    // for running code before app terminates
    WidgetsBinding.instance.addObserver(this);
    titleController = TextEditingController()
      ..addListener(checkForValidNote);
    noteController = TextEditingController()
      ..addListener(checkForValidNote);
    notesProvider = context.read<NotesProvider>();
    notesProvider.addListener(() {
      // if(notesProvider.notes_length < 1) {
      //   Navigator.of(context).pop();
      // }
    });
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        isEditing.value = true;
        isEditingTitle.value = true;
      }
    });

    _noteFocusNode.addListener(() {
      if (_noteFocusNode.hasFocus) {
        isEditing.value = true;
        isEditingTitle.value = false;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _noteFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    if (titleController.text
        .trim()
        .isNotEmpty ||
        noteController.text
            .trim()
            .isNotEmpty) {
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

    // NoteModel note = NoteModel(
    //     title: titleController.text,
    //     note: noteController.text,
    //     bookmarked: !flag);
    context.read<NotesProvider>().editBookmark(note, flag);
  }


  Future<void> submitNote(int index) async {
    if (index != -1) {
      // print('editing now...');
      NoteModel fetchNote = context
          .read<NotesProvider>()
          .notes[index];
      NoteModel newNote = NoteModel(
          title: titleController.text,
          note: noteController.text,
          bookmarked: fetchNote.bookmarked);

      context.read<NotesProvider>().editNote(fetchNote, newNote);
    } else {
      // submit note by clicking check icon
      NoteModel newNote = NoteModel(
          title: titleController.text,
          note: noteController.text,
          bookmarked: false);

      thisNoteIndex =
      await context.read<NotesProvider>().addNoteReturnIndex(newNote);
    }


    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NoteDetailScreen(index - 1)));

    _titleFocusNode.unfocus();
    _noteFocusNode.unfocus();
    setState(() {
      // isEditing = false;
      thisNoteIndex = thisNoteIndex;
      isEditing.value = false;
      isEditingTitle.value = false;

    });
  }

@override
  void didChangeAppLifecycleState(AppLifecycleState state) {


    if(state == AppLifecycleState.inactive) {
      if(checkForValidNote()) {
        submitNote(thisNoteIndex);
      }
    }




    super.didChangeAppLifecycleState(state);
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String formattedTime =
    DateFormat('EEEE, MMMM d, hh:mm a').format(DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (checkForValidNote()) {
          if (isEditing.value) {
            createNote();
          }

          titleController.clear();
          noteController.clear();
        }

        // Navigator.of(context).pop();
        WidgetsBinding.instance.addPostFrameCallback((_) {

          if (Navigator.of(context).canPop()) {

            Navigator.of(context).pop();
          }

        });
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .surface,
          resizeToAvoidBottomInset: true,
          appBar: buildAppBar(context),
          body: ListView(
            children: [
              SizedBox(
                width: double.infinity,
                height: screenSize
                    .height -
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
                      return  EditingNavigationButtons(screenSize: screenSize,);
                    }
                  },
                );
              } else {
                return NavigationBarButtons(thisNoteIndex: thisNoteIndex, screenSize: screenSize,);
              }
            },
            // child: buildNavigationBar(context),
          ),
        ),
      ),
    );
  }

  // Padding buildNavigationBar(BuildContext context) {
  //   return
  // }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 40,
        color: Theme
            .of(context)
            .iconTheme
            .color,
      ),
      actions: [
        ValueListenableBuilder(valueListenable: isEditing,

            builder: (context, value, child) {
              return value ? ValueListenableBuilder<bool>(
                valueListenable: isNoteValid,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: isNoteValid.value ? () {
                      submitNote(thisNoteIndex);
                    } : null,
                    icon: Icon(
                      Icons.check,
                      color: isNoteValid.value ? Colors.orange : Colors.grey,
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
                      editBookmark(note!, !note.bookmarked);
                    },
                    icon: Icon(note != null ? note.bookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_outlined : Icons
                        .bookmark_border_outlined),
                    iconSize: 50,
                    color: Theme
                        .of(context)
                        .iconTheme
                        .color,
                  );
              });
            }),


      ],
    );
  }
}
