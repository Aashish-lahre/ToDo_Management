import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/widgets/editing_navigation_buttons.dart';
import 'package:task_management/widgets/navigation_bar_buttons.dart';

import '../widgets/note_input_widget.dart';
import '../widgets/title_input_widget.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});
  static const routeName = '/addNoteScreen';
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>
    with WidgetsBindingObserver {
  final FocusNode _noteFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  // bool noteHaveBody = false;
  late NotesProvider notesProvider;
  final ValueNotifier<bool> isEditing = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isEditingTitle = ValueNotifier<bool>(false);
  late TextEditingController titleController;
  late TextEditingController noteController;
  final ValueNotifier<bool> isNoteValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> noteHaveBody = ValueNotifier<bool>(false);
  int thisNoteIndex = -1;
  String formattedTime =
      DateFormat('EEEE, MMMM d, hh:mm a').format(DateTime.now());
  late FocusNode lastFocusNode;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  final double titleField = 60;
  final double formattedDate = 25;
  final double titleContainerHeight = 85;
  int _lineCount = 1;
  late StreamSubscription<bool> keyboardSubscription;
  late Completer<void> keyboardVisibleCompleter;
  late KeyboardVisibilityController keyboardVisibilityController;
  late Offset initialPosition;
  bool isDragging = false;
  final double dragThreshold = 10.0; // Adjust the threshold for sensitivity


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
     keyboardVisibilityController = KeyboardVisibilityController();
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);
    noteController.addListener(_updateLineCount);
    keyboardSubscription = keyboardVisibilityController.onChange.listen(ifKeyboardVisible);
    notesProvider = context.read<NotesProvider>();
    titleFocusNodeListener();
    // noteFocusNodeListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

        await makeKeyBoardVisible();

        lastFocusNode = _noteFocusNode;



    });
  }

  Future<void> makeKeyBoardVisible() async {

    keyboardVisibleCompleter  = Completer<void>();
    _noteFocusNode.requestFocus();
    

    
    await keyboardVisibleCompleter.future;
    
  }

  // @override
  // void didChangeMetrics() {
  //   
  //   WidgetsBinding.instance.addPostFrameCallback((callback) {
  //     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  //     
  //     if (keyboardHeight != _keyboardHeight && keyboardHeight == 0) {
  //       setState(() {
  //         noteHaveBody = false;
  //       });
  //     }
  //     if (keyboardHeight != _keyboardHeight && keyboardHeight > 0) {
  //       setState(() {
  //         noteHaveBody = true;
  //       });
  //       scrollDown();
  //     }
  //     setState(() {
  //       _keyboardHeight = keyboardHeight;
  //     });
  //   });
  //   super.didChangeMetrics();
  // }

  void ifKeyboardVisible(bool visible) {
    if(visible && !keyboardVisibleCompleter.isCompleted) {
      keyboardVisibleCompleter.complete();
      
    } else {
      
      noteHaveBody.value = false;

    }
  }

  // @override
  // void didChangeMetrics() {
  //   
  //   WidgetsBinding.instance.addPostFrameCallback((callback) {
  //     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  //     
  //     if (keyboardHeight == 0) {
  //       setState(() {
  //         keyboardVisibilityStatus = false;
  //       });
  //     }
  //     if (keyboardHeight > 0) {
  //       setState(() {
  //         
  //         keyboardVisibilityStatus = true;
  //       });
  //
  //     }
  //
  //   });
  //   super.didChangeMetrics();
  // }

  // void noteFocusNodeListener() {
  //   return _noteFocusNode.addListener(() {
  //     
  //     if (_noteFocusNode.hasFocus) {
  //       
  //       // setState(() {
  //       //   keyboardVisibilityStatus = true;
  //       // });
  //
  //       // 
  //       if (lastFocusNode == _titleFocusNode) {
  //         
  //         // setState(() {
  //         //   noteHaveBody = true;
  //         // });
  //
  //         scrollDown(); // make title visible
  //       }
  //       setState(() {
  //         
  //         lastFocusNode = _noteFocusNode;
  //       });
  //     } else {
  //       
  //     }
  //   });
  // }

  void titleFocusNodeListener() {
    return _titleFocusNode.addListener(titleFocusnodeListener);
  }

  void titleFocusnodeListener() {
    if (_titleFocusNode.hasFocus) {
      setState(() {
        
      lastFocusNode = _titleFocusNode;
      isEditing.value = true;
      isEditingTitle.value = true;

      });
    }
  }

  void scrollDown() {
    // programmatically scroll down --> seeing below content

    

    if (scrollController.position.pixels < 85) {
      
      if(noteHaveBody.value == false) {
        
        noteHaveBody.value = true;
        
      }
      // Future.delayed(const Duration(milliseconds: 50), () {

      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        
        // scrollController.animateTo(titleContainerHeight,
        //     duration: const Duration(milliseconds: 200), curve: Curves.linear);


        // ToDo = try removing bouncing physics before animating


        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
        
      });

      // });
    }
  }

  void scrollUp(double pixel) {
    // programmatically scroll up --> seeing up content
    

    if (scrollController.position.pixels != 0) {
      

      if(scrollController.position.pixels > pixel) {

        // Future.delayed(const Duration(milliseconds: 50), () {
          
          scrollController.animateTo(pixel,
              duration: const Duration(milliseconds: 200), curve: Curves.linear);
          
        // });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // setState(() {
            //   noteHaveBody = false;
            // });
            noteHaveBody.value = false;
          });

      }

    }
  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // lastFocusNode.dispose();
    _noteFocusNode.dispose();
    _titleFocusNode.removeListener(titleFocusnodeListener);
    _titleFocusNode.dispose();
    keyboardSubscription.cancel();

    titleController
      ..removeListener(checkForValidNote)
      ..dispose();
    noteController
      ..removeListener(checkForValidNote)..removeListener(_updateLineCount)..dispose();


    scrollController.dispose();
    // 


    isEditingTitle.dispose();
    isEditing.dispose();
    isNoteValid.dispose();

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

  Future<void> createNote() async {
    NoteModel note = NoteModel(
        title: titleController.text,
        note: noteController.text,
        bookmarked: false);
   await context.read<NotesProvider>().addNote(note, context);

    // TODO sync to synced
  }

  void editBookmark(NoteModel note, bool flag) {
    context.read<NotesProvider>().editBookmark(note, flag);
  }

  Future<void> submitNote(int index) async {
    if (index != -1) {
      // updating the existing note
      NoteModel fetchNote = context.read<NotesProvider>().notes[index];
      NoteModel newNote = NoteModel(
        id: fetchNote.id,
          title: titleController.text,
          note: noteController.text,
          bookmarked: fetchNote.bookmarked);

      await context.read<NotesProvider>().editNote(fetchNote, newNote, context);

      // TODO sync to synced
    } else {
      // creating new note
      // submit note by clicking check icon
      NoteModel newNote = NoteModel(
          title: titleController.text,
          note: noteController.text,
          bookmarked: false);

      thisNoteIndex =
          await context.read<NotesProvider>().addNoteReturnIndex(newNote, context);


      // TODO sync to synced
    }

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
    if (state == AppLifecycleState.inactive) {
      if (checkForValidNote()) {
        submitNote(thisNoteIndex);
      }
    }
    super.didChangeAppLifecycleState(state);
  }



  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;



    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        await onPopScreen(context);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          resizeToAvoidBottomInset: true,
          appBar: buildAppBar(context),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: SizedBox(

                      height: constraints.maxHeight,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildTitleField(context, formattedTime),
                            const Divider(color: Colors.blueGrey,),
                            buildNoteField( constraints),
                          ],
                        ),
                      ),
                    ),
              );
            }
          ),

          bottomNavigationBar: buildBottomNavigation(screenSize),
        ),
      ),
    );
  }

  Future<void> onPopScreen(BuildContext context) async {
    if (checkForValidNote()) {
      if (isEditing.value) {
        // await createNote();
        await submitNote(thisNoteIndex);
      }

      titleController.clear();
      noteController.clear();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) {

        Navigator.of(context).pop();
      }
    });
  }

  ValueListenableBuilder<bool> buildBottomNavigation(Size screenSize) {
    return ValueListenableBuilder(
      valueListenable: isEditing,
      builder: (context, isEditingValue, _) {
        if (isEditingValue) {
          return ValueListenableBuilder(
            valueListenable: isEditingTitle,
            builder: (context, isEditingTitleValue, _) {
              if (isEditingTitleValue) {
                return const SizedBox.shrink();
              } else {
                return EditingNavigationButtons(
                  screenSize: screenSize,
                );
              }
            },
          );
        } else {
          return NavigationBarButtons(
            thisNoteIndex: thisNoteIndex,
            screenSize: screenSize,
          );
        }
      },
      // child: buildNavigationBar(context),
    );
  }

  Listener buildNoteField(BoxConstraints constraints) {


    // bool? keyboardVisibility = KeyboardVisibilityProvider.isKeyboardVisible(context) as bool?;

    
    
    return Listener(
      onPointerDown: (event) {
        // Store the initial position when the pointer goes down
        initialPosition = event.position;
        isDragging = false; // Reset dragging state
      },
      onPointerMove: (PointerMoveEvent event) {
        // Calculate the distance moved
        double deltaX = (event.position.dx - initialPosition.dx).abs();
        double deltaY = (event.position.dy - initialPosition.dy).abs();

        // If the movement exceeds the threshold, it's considered a drag
        if (deltaX > dragThreshold || deltaY > dragThreshold) {
          isDragging = true;
        }
      },
      onPointerUp: (event) {
        if (isDragging) {
          
        } else {
          onNoteBoxClicked();
        }
      },

      child: ValueListenableBuilder(
        valueListenable: noteHaveBody,
        builder: (context, noteHaveBodyValue, child) {
          
          return SizedBox(
            width: double.infinity,
            height: keyboardVisibilityController.isVisible
                ? noteHaveBodyValue
                    ? constraints.maxHeight
                    : constraints.maxHeight * .9
                : constraints.maxHeight * .9,
            child: SingleChildScrollView(
              child: Column(
              
                children: [
                  SizedBox(
                      height: constraints.maxHeight * .8,
                      child: child!),
                  SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight * .1,),
                ],
              ),
            ),
          );
        },
        child: NoteInputWidget(
          haveBody: noteHaveBody.value,
        noteFocusNode: _noteFocusNode,
        noteController: noteController,
      ),
      ),
    );
  }

  void onNoteBoxClicked() {
    if(isEditing.value == false) {
      isEditing.value = true;
      isEditingTitle.value = false;
    }

      // checking if keyboard is visible or not
      if (keyboardVisibilityController.isVisible) {
          // checking if note text field has any content
          if(noteController.text.isNotEmpty || _lineCount > 1) {
              // checking if scroll view is at top (meaning if title visible)
              if(scrollController.position.pixels == 0) {
                // do nothing
              } else {
                  // scroll view is not at the top (huge chances title is might not be visible)

                // checking if there is not much new lines
                if(_lineCount < 5) {
                  
                    scrollUp(0); // make title visible
                } else {
                    // do nothing
                }
              }
          } else {
            // note text field is empty
            // 

            // checking if title box is not visible
            if (scrollController.position.pixels > titleContainerHeight) {

              // if(lastFocusNode == _titleFocusNode) {

                scrollUp(0); // make title visible
              // } else {
                // do nothing
              // }
            } else {
              // title box might be visible
              if(noteController.text.isNotEmpty || _lineCount > 1) {

                // checking if the note text is on less than 5 lines
                if(_lineCount < 5) {
                  
                  scrollUp(0); // scroll upto pixel 0 (complete scroll)
                } else {

                  // checking if the note text is on 5 lines
                  if(noteController.text.isNotEmpty || _lineCount == 5) {
                    

                    scrollUp(0);
                  } else {
                    // checking if the note text is big enough to hide title box
                    if(noteController.text.isNotEmpty || _lineCount > 5) {
                         // don't scroll or do nothing
                    } else {
                      // un reachable condition, because all situations are handle
                    }
                  }
                }

              } else {
                // note field has no content or maybe one liner content

                // i am also getting here when focus transfer from title to note

                
                if(lastFocusNode == _titleFocusNode) {
                  // do nothing, this situation is handled by note listener

                  setState(() {
                    
                    lastFocusNode = _noteFocusNode;
                  });

                  

                  scrollDown();



                } else {
                  // scrollUp(0);
                  // do nothing
                }

              }

            }

          }

      }
      // keyboard is not visible
      else {


        // note field has content
        if(noteController.text.isNotEmpty || _lineCount > 1) {

          // checking if scroll view is at top (meaning title is visible)
          if(scrollController.position.pixels == 0) {
              scrollDown(); // hiding title
          } else {
            // scroll view is not at top (big chances title box is not visible)

            // jump to the active line position.
            // or maybe just do nothing, framework will handle it by itself

          }
        } else {
          // note field do not have content

// trail error code

          
          WidgetsBinding.instance.addPostFrameCallback((_) async{
            

             await makeKeyBoardVisible();
             
            scrollDown();
          });

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   
          //   setState(() {
          //     keyboardVisibilityStatus = true;
          //   });

            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //
            // });
          // });

        }

      }

    }


  void _updateLineCount() {
    final text = noteController.text;
    // Counting the number of newline characters + 1
    final newLineCount = '\n'.allMatches(text).length + 1;
    if (newLineCount != _lineCount) {
      setState(() {
        _lineCount = newLineCount;
      });
    }
  }

  Listener buildTitleField(BuildContext context, String formattedTime) {
    return Listener(
      onPointerUp: onTitleBoxClicked,
      child: SizedBox(
        // height: screenSize.height * .1 - 15,
        height: titleContainerHeight,
        width: double.infinity,
        child: TitleInputWidget(
            titleController: titleController,
            context: context,
            noteFocusNode: _noteFocusNode,
            titleFocusNode: _titleFocusNode,
            formattedTime: formattedTime),
      ),
    );
  }

  void onTitleBoxClicked(_) {
      // Do nothing...
    }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: kToolbarHeight,
      leading: IconButton(
        onPressed: ()async {
          await onPopScreen(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 25,
        color: Theme.of(context).iconTheme.color,
      ),
      actions: [
        ValueListenableBuilder(
            valueListenable: isEditing,
            builder: (context, value, child) {
              return value
                  ? ValueListenableBuilder<bool>(
                      valueListenable: isNoteValid,
                      builder: (context, value, child) {
                        return IconButton(
                          onPressed: isNoteValid.value
                              ? () {
                                  submitNote(thisNoteIndex);
                                }
                              : null,
                          icon: Icon(
                            Icons.check,
                            color:
                                isNoteValid.value ? Colors.orange : Colors.grey,
                          ),
                          iconSize: 30,
                        );
                      },
                    )
                  : Consumer<NotesProvider>(builder: (_, noteProvider, child) {
                      late NoteModel? note;
                      try {
                        note = noteProvider.notes.elementAt(thisNoteIndex);
                      } on RangeError {
                        note = null;
                      }

                      // 
                      return IconButton(
                        onPressed: () {
                          editBookmark(note!, !note.bookmarked);
                        },
                        icon: Icon(note != null
                            ? note.bookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border_outlined
                            : Icons.bookmark_border_outlined),
                        iconSize: 30,
                        color: Theme.of(context).iconTheme.color,
                      );
                    });
            }),
      ],
    );
  }
}

