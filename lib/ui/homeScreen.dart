import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/notes_model.dart';
import 'package:task_management/ui/addNoteScreen.dart';
import 'package:task_management/ui/note_detail_screen.dart';
import 'package:task_management/widgets/appbar_action_widgets.dart';
import 'package:task_management/widgets/list_tile.dart';
import '../common/constants.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  void openDrawer(bool flag) {
    // true --> open Drawer
    // false --> close Drawer


  }

  String formatSubtitle(String input) {
    // Define a maximum length for truncation
    const int maxLength = 30;

    // Check if the input contains line breaks
    if (input.contains('\n')) {
      // If the input contains line breaks, return the string up to the first line break
      return input.split('\n')[0];
    } else if (input.length > maxLength) {
      // If the input doesn't contain line breaks and is longer than maxLength, truncate it
      return '${input.substring(0, maxLength)}...';
    } else {
      // If the input doesn't meet the conditions above, return it as is
      return input;
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: buildAppBar,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints  constraints) {
            if(constraints.maxWidth <= 1024 && constraints.maxWidth >= 600) {
              return TabletLayout();
            }
            if(constraints.maxWidth > 1024 ) {
              return DesktopLayout();
            }
            if(constraints.maxWidth < 600) {

              return MobileLayout(context);
            }

            return const Center(child: Text('Layout builder constraint problem'),);

          },
        ),
      ),
    );
  }

  AppBar get buildAppBar {
    return AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Task', style: TextStyle(fontSize: titleSize, color: Colors.white)
              ),

             Row(
               mainAxisSize: MainAxisSize.min,
               children: getHomeScreenAppbarActionWidgets(),
             )
            ],
          ),
        ),

      );
  }

  Widget TabletLayout() {
    return const Text("Implement to tablet....");
  }
  Widget DesktopLayout() {
    return const Text("Implement to desktop and laptop....");
  }
  Widget MobileLayout(BuildContext context) {

    List<NoteModel> allNotes = context.watch<NotesProvider>().notes;
    int notesLength = allNotes.length;
    return Container(
      // decoration: BoxDecoration(color: Colors.lightBlueAccent),
      width: double.infinity,
      height: MediaQuery.of(context).size.height - buildAppBar.toolbarHeight!,

      child:  Stack(
        children: [

          // Listview
          Positioned.fill(

            child: ListView.builder(
                itemCount: notesLength,
                itemBuilder: (context, index) {

                  String formattedTime = DateFormat('EEEE, MMMM d, hh:mm a').format(allNotes[index].time);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 10),
                                  Text("Delete"),
                                ],
                              ),
                            ),
                          ],
                        ).then((value) {
                          if (value == 1) {
                            context.read<NotesProvider>().deleteNote(
                              allNotes[index],
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
                        customColor: listItemColors[index % 6],
                        title: allNotes[index].title,
                        subtitle: formatSubtitle(allNotes[index].note),
                      ),
                    ),
                  );
                }),
          ),

          // Add Note
          Positioned(
            bottom: 20,
            right: 30,
            child:
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {


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
              },
              child:  const CircleAvatar(
                radius: 30,
                child: Icon(Icons.add, semanticLabel: 'Add Note',),),
            ),
          ),

          // Search
          Positioned(
            bottom: 40,
            right: 110,
            child:
            InkWell(
              onTap: () {},
              child: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.search),),
            ),
          ),

          // Profile
          Positioned(
            bottom: 20,
            right: 190,
            child:
            InkWell(
              onTap: () {},
              child: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),),
            ),
          ),

        ],
      ),
    );
  }

}
