import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/utility/scaffold_message.dart';
import 'package:task_management/network/data/header_message_provider.dart';
import 'package:task_management/network/data/note_detail_screen_provider.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/network/models/header_message_model.dart';
import 'package:task_management/screens/add_note_screen.dart';
import 'package:task_management/screens/note_detail_screen.dart';
import 'package:task_management/screens/profile.dart';
import 'package:task_management/widgets/homeScreenWidget/appbar_action_widgets.dart';
import 'package:task_management/widgets/homeScreenWidget/close_search_container.dart';
import 'package:task_management/widgets/homeScreenWidget/header_message_widget.dart';

import 'package:task_management/widgets/homeScreenWidget/search_widget.dart';
import 'package:task_management/widgets/themedWidgets/themedIcon.dart';
import '../common/constants.dart';
import '../widgets/themedWidgets/themed_circle_avatar.dart';


/// TODO: when exclusive lists are empty --> synced
/// Todo: when featching note from firestore, the dates are not correct, they some the current moment time, not the time they were created.
/// when exclusive lists are not empty --> not synced
///   in this case if i create a note, but failed to update in firestore(for any reason, maybe no internet)
///   keep it not synced
/// when exclusive lists are empty and i create a note and update in firestore successfully
///   check if exclusive lists are empty
///     if true --> i don't have to fetching notes from firestore
///     i can just make sync --> synced
///   if updating note in firestore fails
///     sync --> not synced
///
/// when we create note and successfully update it on firestore, we don't
/// have to fetch notes from firestore and check if are equal
///
/// when app start
///   if user and not isSynced
///     only local notes
///   if user and yes isSynced
///     initialise the exclusive lists
///       if equal --> synced
///       if not equal --> not synced
///       if error --> not synced
///         show header message
///     when create note
///       add to local note
///       update firestore
///         if sucessful
///           check exclusive lists are empty
///             if true
///               synced
///             if false
///               not synced
///         if unsucessful
///           unsynced
///     when update note
///       deletes the previous note
///       add a new note
///       update the firestore
///     when delete note
///
///
///
///
///
///
///

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  ValueNotifier<bool> isSearching = ValueNotifier(false);
  final FocusNode searchFocusNode = FocusNode();
  bool isCustomColor = false;
  late double _keyboardHeight;
  bool isAppbarExpanded = true;
  double expandedHeight = 180;
  double collapsedHeight = 80;
  double threshold = 50;
  double heightDifference = 100;
  late ScrollController scrollController;
  bool scrollingViaUser = false;

  void openDrawer(bool flag) {
    // true --> open Drawer
    // false --> close Drawer
  }

  @override
  void initState() {
    print('homescreen initializer gets called');
    WidgetsBinding.instance.addObserver(this);
    _keyboardHeight = 0;
    scrollController = ScrollController(initialScrollOffset: 0);
    super.initState();
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
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

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      scrollingViaUser = true;
    }

    if (notification is ScrollEndNotification) {
      print('scroll end notification global : ${notification.metrics.pixels}');

      if (scrollingViaUser == true) {
        print(
            'scroll end notification only by user : ${notification.metrics.pixels}');
        if (isAppbarExpanded) {
          if (scrollController.offset <= threshold) {
            print(
                'scroll controller offset is less than or equal to threshold');
            // scroll controller offset is less than or equal to threshold
            // animate to 0
            scrollingViaUser =
                false; // to not execute this full if else code block when programmatically scrolling
            Future.delayed(
              const Duration(milliseconds: 50),
              () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 100),
                  // curve: Curves.easeIn,
                  curve: Curves.linear,
                );
              },
            );
          } else {
            // more than threshold
            if (scrollController.offset < heightDifference) {
              // more than threshold but less than height difference
              // animate to 100
              scrollingViaUser =
                  false; // to not execute this full if else code block when programmatically scrolling
              Future.delayed(
                const Duration(milliseconds: 50),
                () {
                  scrollController.animateTo(
                    expandedHeight - collapsedHeight,
                    duration: const Duration(milliseconds: 100),
                    // curve: Curves.easeIn,
                    curve: Curves.linear,
                  );
                },
              );
              isAppbarExpanded = false;
            } else {
              // must be equals to or more than height difference
              if (scrollController.offset >= heightDifference) {
                // do not animate anything
                isAppbarExpanded = false;
              } else {
                print(
                    'wierd/unknown state, scroll controller offset should be equals to height difference, but it is not');
              }
            }
          }
        } else {
          if (scrollController.offset > expandedHeight - collapsedHeight) {
            // do nothing
          } else {
            if (scrollController.offset >= threshold) {
              // more than threshold
              // animate to 100
              scrollingViaUser =
                  false; // to not execute this full if else code block when programmatically scrolling
              Future.delayed(
                const Duration(milliseconds: 50),
                () {
                  scrollController.animateTo(
                    expandedHeight - collapsedHeight,
                    duration: const Duration(milliseconds: 100),
                    // curve: Curves.easeIn,
                    curve: Curves.linear,
                  );
                },
              );
            } else {
              // less than threshold
              if (scrollController.offset > 0) {
                // less than threshold but more than 0
                // animate to 0
                scrollingViaUser =
                    false; // to not execute this full if else code block when programmatically scrolling
                Future.delayed(
                  const Duration(milliseconds: 50),
                  () {
                    scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 100),
                      // curve: Curves.easeIn,
                      curve: Curves.linear,
                    );
                  },
                );
                isAppbarExpanded = true;
              } else {
                // must be equal to 0
                if (scrollController.offset == 0) {
                  // do not animate anything
                  isAppbarExpanded = true;
                } else {
                  print(
                      'wierd/unknown state, scroll controller should be equal to 0, but it is not');
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  Widget subtitleAndTime(BuildContext context, String subtitle, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle.isEmpty ? " " : subtitle,
          // style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1, // Adjust maxLines as needed
        ),
        const SizedBox(height: 2),
        // Adds some spacing between subtitle and time
        Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.black,
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
      ),
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

              child: buildNavigationButtons(context),
            ),
          ),
        ],
      ),
    );
  }

  Row buildNavigationButtons(BuildContext context) {
    return Row(
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
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName);
                  },
                  child: const ThemedCircleAvatar(
                    // backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    radius: 30,
                    child: ThemedIcon(Icons.person),
                  ),
                ),
                InkWell(
                  onTap: () => isSearching.value = true,
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
            );
  }

  Widget buildTabletLayout() {
    return const Text("Implement to tablet....");
  }

  Widget buildDesktopLayout() {
    return const Text("Implement to desktop and laptop....");
  }

  Widget buildMobileLayout(BuildContext context, BoxConstraints constraints, Size screenSize) {
    List<NoteModel> allNotes = context.watch<NotesProvider>().notes;
    // print('allNotes in homeScreen : ${allNotes[0].id}');
    int notesLength = allNotes.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: handleScrollNotification,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [


            //HeaderMessage if Available
            Consumer<HeaderMessageProvider>(
              builder: (context, messageProvider, _) {
                HeaderMessageModel? headerMessage = messageProvider.headerMessage;
                if(headerMessage == null) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }
                if(headerMessage.callback == null) {
                  // header message with no button

                  return SliverToBoxAdapter(child: HeaderMessageWidget(headerMessage: headerMessage));
                }

                if(headerMessage.callback != null) {
                  return SliverToBoxAdapter(child: HeaderMessageWithButton(headerMessage: headerMessage));
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink(),);



              },

            ),

            // Appbar
            buildSliverAppBar(),

            // Search Widget
            SliverToBoxAdapter(
              child: ValueListenableBuilder(
                valueListenable: isSearching,
                builder: (context, value, _) {
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
            ),

            // Notes List
            buildSliverList(notesLength, allNotes, screenSize),
          ],
        ),
      ),
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: collapsedHeight,
            toolbarHeight: 0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {

                double paddingTop =
                    ((constraints.maxHeight - 80) / (180 - 80)) * 120;
                double percent = (constraints.maxHeight - kToolbarHeight) /
                        (180 - kToolbarHeight) +
                    1;

                return SizedBox(
                  height: constraints.maxHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Notes Text
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16),
                              child: Text('Notes',
                                  style: TextStyle(fontSize: 20 * percent)),
                            ),
                          ],
                        ),
                      ),

                      // Action Widgets
                      Expanded(
                        flex: 1,
                        child: HomeScreenAppbarActionWidget(paddingTop: paddingTop),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

void deleteNote(LongPressStartDetails details, BuildContext context, Size screenSize, int index) {
  final tapPosition = details.globalPosition;
  buildShowMenu(context, tapPosition, screenSize).then((value) {
    if (value == 1) {
      context.read<NotesProvider>().deleteNote(
          index, context
      );
    }
  });
}

  SliverList buildSliverList(
      int notesLength, List<NoteModel> allNotes, Size screenSize) {
    return SliverList(
      delegate:
          SliverChildBuilderDelegate(childCount: notesLength, (context, index) {
        String formattedTime =
            DateFormat('MMMM d, hh:mm a').format(allNotes[index].time);

        return GestureDetector(
          onLongPressStart: (details) {
            deleteNote(details, context, screenSize, index);
          },
          child: buildListTile(context, index, allNotes, formattedTime),
        );
      }),
    );
  }

  Padding buildListTile(BuildContext context, int index,
      List<NoteModel> allNotes, String formattedTime) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: ListTile(
          onTap: () {
            Provider.of<NoteDetailScreenProvider>(context, listen: false).setIndex(index);
            Navigator.of(context).pushNamed(NoteDetailScreen.routeName);
          },
          title: allNotes[index].title.isNotEmpty
              ? Text(allNotes[index].title)
              : null,
          subtitle:
              subtitleAndTime(context, allNotes[index].note, formattedTime),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        ),
      ),
    );
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
    print('Navigating to add note screen...');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(

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
    });

  }
}
