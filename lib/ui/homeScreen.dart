import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/ui/addNoteScreen.dart';
import 'package:task_management/ui/note_detail_screen.dart';
import 'package:task_management/widgets/appbar_action_widgets.dart';
import 'package:task_management/widgets/close_search_container.dart';
import 'package:task_management/widgets/list_tile.dart';
import 'package:task_management/widgets/search_widget.dart';
import '../common/constants.dart';

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
      if(keyboardHeight != _keyboardHeight && keyboardHeight == 0) {
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.black,
      appBar: buildAppBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints  constraints) {
          if(constraints.maxWidth <= 1024 && constraints.maxWidth >= 600) {
            return buildTabletLayout();
          }
          if(constraints.maxWidth > 1024 ) {
            return buildDesktopLayout();
          }
          if(constraints.maxWidth < 600) {

            return buildMobileLayout(context, constraints);
          }

          return const Center(child: Text('Layout builder constraint problem'),);

        },
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // bottom Navigation
          AnimatedContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.only(bottom: 15),
            duration: const Duration(milliseconds: 100),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.primary,
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                    child: Icon(Icons.home, color: Theme.of(context).iconTheme.color,),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                    child: Icon(Icons.person, color: Theme.of(context).iconTheme.color,),
                  ),
                ),
                InkWell(
                  onTap: () {isSearching.value = true;},
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                    child: Icon(Icons.search, color: Theme.of(context).iconTheme.color,),
                  ),
                ),
                InkWell(
                  onTap: () => onAddNotePress(context),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                    child: Icon(Icons.add, color: Theme.of(context).iconTheme.color,),
                  ),
                ),

              ],
            ),

          ),
        ],
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
        // backgroundColor: Colors.black,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Task', style: GoogleFonts.inter(
                textStyle:  Theme.of(context).textTheme.titleMedium,
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

  Widget buildMobileLayout(BuildContext context, BoxConstraints constraints)  {

    List<NoteModel> allNotes =  context.watch<NotesProvider>().notes;
    int notesLength = allNotes.length;
    return Column(
      children: [
        // Search Widget
        ValueListenableBuilder(
          valueListenable: isSearching,
          builder: (context, value, _) {
            return AnimatedOpacity(
              opacity: value ? 1.0 : 0.0,  // Fade in when value is true, fade out when false
              duration: const Duration(milliseconds: 300),  // Adjust this duration to match your animation speed
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
                    : null,  // When value is false, don't render the child
              ),
            );
          },
        ),

        // ListView Widget
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // decoration: const BoxDecoration(color: Colors.lightBlueAccent),
          width: double.infinity,
          height:  constraints.maxHeight * .9,
          child:  buildNotesListViewWidget(notesLength, allNotes),
        ),
      ],
    );
  }

  ListView buildNotesListViewWidget(int notesLength, List<NoteModel> allNotes) {
    return ListView.builder(
                itemCount: notesLength,
                itemBuilder: (context, index) {

                  String formattedTime = DateFormat('MMMM d, hh:mm a').format(allNotes[index].time);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onLongPressStart: (details) {
                        final tapPosition = details.globalPosition;
                        print('long pressed');
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            tapPosition.dx,
                            tapPosition.dy,
                            MediaQuery.of(context).size.width - tapPosition.dx,
                            MediaQuery.of(context).size.height - tapPosition.dy,
                          ),
                          items: [
                             PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text("Delete", style: Theme.of(context).textTheme.bodyMedium,),
                                ],
                              ),
                            ),
                          ],
                        ).then((value) {
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
                        customColor: isCustomColor ? listItemColors[index % 6] : Theme.of(context).colorScheme.primary,
                        title: allNotes[index].title,
                        subtitle: allNotes[index].note,

                      ),
                    ),
                  );
                });
  }



  void onAddNotePress(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddNoteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
