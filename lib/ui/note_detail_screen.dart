import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/notes_model.dart';
import 'package:task_management/widgets/note_input_widget.dart';
import 'package:task_management/widgets/title_input_widget.dart';

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
  late List<NoteModel> notes;
  late NoteModel note;
  bool isEditingMode = false;
  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(true);

  void setEditingMode() {
    setState(() {
      isEditingMode = true;
    });
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

  void submitNote() {
    note.title = titleController.text;
    note.note = noteController.text;
    note.time = DateTime.now();
    context.read<NotesProvider>().editNote(note);
  }

  void recreateDetailScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => NoteDetailScreen(widget.noteIndex)));
  }

  @override
  void initState() {
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);

    titleFocusNode.addListener(() {
      if (titleFocusNode.hasFocus) {
        setEditingMode();
      }
    });

    noteFocusNode.addListener(() {
      if (noteFocusNode.hasFocus) {
        setEditingMode();
      }
    });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notes = context.read<NotesProvider>().notes;
      note = notes[widget.noteIndex];
      titleController.text = note.title;
      noteController.text = note.note;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // notesLength = context.watch<NotesProvider>().notes_length;
    notes = context.watch<NotesProvider>().notes;

    if (notes.length <= widget.noteIndex) {
      return const Scaffold(
        backgroundColor: Colors.black,
      );
    }

    note = notes[widget.noteIndex];

    String formattedTime =
        DateFormat('EEEE, MMMM d, hh:mm a').format(note.time);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (checkForValidNote()) {
          submitNote();
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
        appBar: buildAppBar(context, note.bookmarked),
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
        bottomNavigationBar: buildNavigationBar(context),
      )),
    );
  }

  AppBar buildAppBar(BuildContext context, bool isBookmarked) {
    return AppBar(
      toolbarHeight: 100,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 40,
      ),
      actions: [
        !isEditingMode
            ? IconButton(
                onPressed: () {
                  context.read<NotesProvider>().editBookmark(note);
                },
                icon: Icon(isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border_outlined),
                iconSize: 50,
              )
            : ValueListenableBuilder<bool>(
                valueListenable: isNoteValid,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: isNoteValid.value
                        ? () {
                            submitNote();
                            recreateDetailScreen();
                          }
                        : null,
                    icon: Icon(
                      Icons.check,
                      color: isNoteValid.value ? Colors.yellow : Colors.grey,
                    ),
                    iconSize: 50,
                  );
                },
              )
      ],
    );
  }

  Padding buildNavigationBar(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: navBg.withOpacity(0.8),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: navBg.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20),
          ],
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!isEditingMode)
              IconButton(
                  onPressed: () {
                    context.read<NotesProvider>().deleteNote(note);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
