import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/utility/scaffold_message.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/ui/add_note_screen.dart';
import 'package:task_management/ui/note_detail_screen.dart';
import 'package:task_management/widgets/appbar_action_widgets.dart';
import 'package:task_management/widgets/close_search_container.dart';
import 'package:task_management/widgets/list_tile.dart';
import 'package:task_management/widgets/search_widget.dart';
import 'package:task_management/widgets/themedWidgets/themedIcon.dart';
import '../common/constants.dart';
import '../widgets/themedWidgets/themed_circle_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  ValueNotifier<bool> isSearching = ValueNotifier(false);
  final FocusNode searchFocusNode = FocusNode();
  bool isCustomColor = false;
  late double _keyboardHeight;

  void openDrawer(bool flag) {
    // true --> open Drawer
    // false --> close Drawer
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _keyboardHeight = 0;
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (keyboardHeight != _keyboardHeight && keyboardHeight == 0) {
        searchFocusNode.unfocus();
      }
      setState(() {
        _keyboardHeight = keyboardHeight;
      });
    });
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.black,
      appBar: buildAppBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth <= 1024 && constraints.maxWidth >= 600) {
            return buildTabletLayout();
          }
          if (constraints.maxWidth > 1024) {
            return buildDesktopLayout();
          }
          if (constraints.maxWidth < 600) {
            return buildMobileLayout(context, constraints, screenSize);
          }

          return const Center(
            child: Text('Layout builder constraint problem'),
          );
        },
      ),
      bottomNavigationBar: buildNavigationBar(context, screenSize),
    );
  }



  Material buildNavigationBar(BuildContext context, Size screenSize) {
    return Material(
      color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // bottom Navigation
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(bottom: 15),
              // duration: const Duration(milliseconds: 100),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: const ThemedCircleAvatar(
                      radius: 30,
                      child: ThemedIcon(Icons.home_rounded),
                    ),
                  ),
                  InkWell(
                    onTap: () => scaffoldMessage(message: 'Profile coming Soon...', context:  context, screenSize:  screenSize),
                    child: const ThemedCircleAvatar(
                      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      radius: 30,
                      child: ThemedIcon(Icons.person),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isSearching.value = true;
                    },
                    child: const ThemedCircleAvatar(
                      radius: 30,
                      child: ThemedIcon(Icons.search),
                    ),
                  ),
                  InkWell(
                    onTap: () => onAddNotePress(context),
                    child: const ThemedCircleAvatar(
                      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      radius: 30,
                      child: ThemedIcon(Icons.add),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
      // backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Task',
              style: GoogleFonts.inter(
                // textStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: getHomeScreenAppbarActionWidgets(context),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return const Text("Implement to tablet....");
  }

  Widget buildDesktopLayout() {
    return const Text("Implement to desktop and laptop....");
  }

  Widget buildMobileLayout(
      BuildContext context, BoxConstraints constraints, Size screenSize) {
    List<NoteModel> allNotes = context.watch<NotesProvider>().notes;
    int notesLength = allNotes.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search Widget
          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, value, _) {
              print('isSearching : ${isSearching.value}');
              return AnimatedOpacity(
                opacity: value ? 1.0 : 0.0,
                // Fade in when value is true, fade out when false
                duration: const Duration(milliseconds: 300),
                // Adjust this duration to match your animation speed
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: value ? constraints.maxHeight * .1 : 0,
                  // color: Colors.lime,
                  child: value
                      ? Center(
                          child: Row(
                            children: [
                              SearchWidget(
                                focusNode: searchFocusNode,
                                parentHeight: constraints.maxHeight * .1,
                                parentWidth: double.infinity,
                              ),
                              const SizedBox(width: 20),
                              CloseSearchContainer(
                                searchFocusNode: searchFocusNode,
                                notifier: isSearching,
                              ),
                            ],
                          ),
                        )
                      : null, // When value is false, don't render the child
                ),
              );
            },
          ),

          // ListView Widget
          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, isSearchingValue, _) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                width: double.infinity,
                // height:  isSearching.value ? constraints.maxHeight  * .9 : constraints.maxHeight,
                // height: 400,
                height: isSearching.value
                    ? constraints.maxHeight * .9
                    : constraints.maxHeight,
                child:
                    buildNotesListViewWidget(notesLength, allNotes, screenSize),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView buildNotesListViewWidget(
      int notesLength, List<NoteModel> allNotes, Size screenSize) {
    return ListView.builder(
        itemCount: notesLength,
        itemBuilder: (context, index) {
          // print(allNotes[index].title);
          String formattedTime =
              DateFormat('MMMM d, hh:mm a').format(allNotes[index].time);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: GestureDetector(
              onLongPressStart: (details) {
                final tapPosition = details.globalPosition;
                buildShowMenu(context, tapPosition, screenSize).then((value) {
                  if (value == 1) {
                    context.read<NotesProvider>().deleteNote(
                          index,
                        );
                  }
                });
              },
              child: ListTileWidget(
                callback: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => NoteDetailScreen(index),
                  ),
                ),
                time: formattedTime,
                customColor: isCustomColor
                    ? listItemColors[index % 6]
                    : Theme.of(context).colorScheme.surface,
                title: allNotes[index].title,
                subtitle: allNotes[index].note,
              ),
            ),
          );
        });
  }

  Future<int?> buildShowMenu(
      BuildContext context, Offset tapPosition, Size screenSize) {
    return showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        screenSize.width - tapPosition.dx,
        screenSize.height - tapPosition.dy,
      ),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.delete),
              const SizedBox(width: 10),
              Text(
                "Delete",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onAddNotePress(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddNoteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
