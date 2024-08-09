import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/models/notes_model.dart';
import 'package:task_management/ui/addNoteScreen.dart';
import 'package:task_management/ui/noteDetailScreen.dart';
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
    return Text("Implement to tablet....");
  }
  Widget DesktopLayout() {
    return Text("Implement to desktop and laptop....");
  }
  Widget MobileLayout(BuildContext context) {
    int notesLength = context.watch<NotesProvider>().notes.length;
    List<NoteModel> allNotes = context.read<NotesProvider>().notes;
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
                    child: ListTileWidget(
                        callback: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>  NoteDetailScreen(allNotes[index]))),
                        time: formattedTime,
                      customColor: listItemColors[index % 6],
                      title: allNotes[index].title,
                      subtitle: formatSubtitle(allNotes[index].note),




                    )
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

                print('tapped');

                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AddNoteScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
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
              child:  CircleAvatar(
                radius: 30,
                child: Icon(Icons.add),),
            ),
          ),

          // Search
          Positioned(
            bottom: 40,
            right: 110,
            child:
            InkWell(
              onTap: () {},
              child: CircleAvatar(
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
              child: CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),),
            ),
          ),

        ],
      ),
    );
  }

}
