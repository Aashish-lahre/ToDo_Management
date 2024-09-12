import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/widgets/note_input_widget.dart';
import 'package:task_management/widgets/title_input_widget.dart';

import '../widgets/editing_navigation_buttons.dart';
import '../widgets/navigation_bar_buttons.dart';

class NoteDetailScreen extends StatefulWidget {
  final int noteIndex;


  const NoteDetailScreen(this.noteIndex, {super.key});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> with WidgetsBindingObserver  {
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


  final ValueNotifier<bool> noteHaveBody = ValueNotifier<bool>(false);

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
  final double dragThreshold = 10.0;
  late String formattedTime;


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
    WidgetsBinding.instance.addObserver(this);
    keyboardVisibilityController = KeyboardVisibilityController();
    titleController = TextEditingController()..addListener(checkForValidNote);
    noteController = TextEditingController()..addListener(checkForValidNote);
    noteController.addListener(_updateLineCount);
    keyboardSubscription = keyboardVisibilityController.onChange.listen(ifKeyboardVisible);

    titleFocusNode.addListener(() {
      if (titleFocusNode.hasFocus) {
        isEditing.value = true;
        isEditingTitle.value = true;
      }
    });
    noteProvider = context.read<NotesProvider>();
    note = noteProvider.notes[widget.noteIndex];
    titleFocusNodeListener();
    formattedTime = DateFormat('EEEE, MMMM d, hh:mm a').format(note.time);

    // isBookmark.value = noteProvider.notes[widget.noteIndex].bookmarked;
    isBookmark.value = note.bookmarked;

    noteProvider.addListener(() {


      if(noteProvider.notes.elementAtOrNull(widget.noteIndex) != null) {
        note = noteProvider.notes[widget.noteIndex];
        isBookmark.value = note.bookmarked;

      }


    });




    titleController.text = note.title;
    noteController.text = note.note;
    super.initState();
  }

  Future<void> makeKeyBoardVisible() async {
    
    keyboardVisibleCompleter  = Completer<void>();
    noteFocusNode.requestFocus();
    

    
    await keyboardVisibleCompleter.future;
    
  }

  void ifKeyboardVisible(bool visible) {
    if(visible && !keyboardVisibleCompleter.isCompleted) {
      keyboardVisibleCompleter.complete();
      
    } else {
      
      noteHaveBody.value = false;

    }
  }

  void titleFocusNodeListener() {
    return titleFocusNode.addListener(titleFocusnodeListener);
  }

  void titleFocusnodeListener() {
    if (titleFocusNode.hasFocus) {
      setState(() {
        
        lastFocusNode = titleFocusNode;
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
    titleController
      ..removeListener(checkForValidNote)
      ..dispose();
    noteController
      ..removeListener(checkForValidNote)..removeListener(_updateLineCount)..dispose();
    noteFocusNode.dispose();
    titleFocusNode.removeListener(titleFocusnodeListener);
    titleFocusNode.dispose();
    keyboardSubscription.cancel();
    scrollController.dispose();
    // 


    isEditingTitle.dispose();
    isEditing.dispose();
    isNoteValid.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      if (checkForValidNote()) {
        submitNote();
      }
    }
    super.didChangeAppLifecycleState(state);
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

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;



    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        onPopInvoke(context);
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

  // ValueListenableBuilder<bool> buildBottomNavigation(Size screenSize) {
  //   return ValueListenableBuilder(
  //           valueListenable: isEditing,
  //           builder: (context, isEditingValue, child) {
  //             if (isEditingValue) {
  //               return ValueListenableBuilder(
  //                 valueListenable: isEditingTitle,
  //                 builder: (context, isEditingTitleValue, child) {
  //                   if (isEditingTitleValue) {
  //                     return const SizedBox.shrink();
  //                   } else {
  //                     return  EditingNavigationButtons(screenSize: screenSize,);
  //                   }
  //                 },
  //               );
  //             } else {
  //               return  NavigationBarButtons(thisNoteIndex: widget.noteIndex, screenSize: screenSize,);
  //             }
  //           },
  //           // child: buildNavigationBar(context),
  //         );
  // }
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
            thisNoteIndex: noteProvider.notes.indexOf(note),
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
          noteFocusNode: noteFocusNode,
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

            
            if(lastFocusNode == titleFocusNode) {
              // do nothing, this situation is handled by note listener

              setState(() {
                
                lastFocusNode = noteFocusNode;
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

  SizedBox buildTitleField(BuildContext context, String formattedTime) {
    return SizedBox(
      // height: screenSize.height * .1 - 15,
      height: titleContainerHeight,
      width: double.infinity,
      child: TitleInputWidget(
          titleController: titleController,
          context: context,
          noteFocusNode: noteFocusNode,
          titleFocusNode: titleFocusNode,
          formattedTime: formattedTime),
    );
  }

  void onPopInvoke(BuildContext context) {
    if (checkForValidNote()) {
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
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      toolbarHeight: kToolbarHeight,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 25,
        color: Theme.of(context).iconTheme.color,
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: isEditing,
          builder: (context, isEditingValue, child) {
            return isEditingValue
                ? ValueListenableBuilder<bool>(
              valueListenable: isNoteValid,
              builder: (context, isNoteValidValue, child) {
                return IconButton(
                  onPressed: isNoteValidValue
                      ? () {

                    submitNote();

                  }
                      : null,
                  icon: Icon(
                    Icons.check,
                    color:
                    isNoteValidValue ? Colors.yellow : Colors.grey,
                  ),
                  iconSize: 30,
                );
              },
            )
                : ValueListenableBuilder<bool>(
              valueListenable: isBookmark,
              builder: (context, isBookMarkValue, child) {

                return IconButton(
                  onPressed: () {

                    context
                        .read<NotesProvider>()
                        .editBookmark(note, !isBookMarkValue);
                  },
                  icon: Icon(isBookMarkValue
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined),
                  iconSize: 30,
// color: Theme.of(context).iconTheme.color,
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


