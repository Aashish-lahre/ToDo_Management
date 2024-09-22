import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/utility/scaffold_message.dart';
import 'package:task_management/network/data/sync_provider.dart';

import 'package:task_management/screens/settings/settings_screen.dart';

import '../../network/data/notes/notes_provider.dart';

// Row HomeScreenAppbarActionWidget(
//     {required BuildContext context, required double paddingTop}) {
//   Size screenSize = MediaQuery.of(context).size;
//   double _width = 40;
//   double _height = 40;
//   Color containerColor = Theme.of(context).colorScheme.surface;
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(top: paddingTop),
//         child: Container(
//           width: _width,
//           height: _height,
//           decoration: BoxDecoration(
//               color: containerColor, borderRadius: BorderRadius.circular(10)),
//           child: IconButton(
//             onPressed: () => scaffoldMessage(
//                 message: 'Feature coming soon...',
//                 context: context,
//                 screenSize: screenSize),
//             icon: const Icon(Icons.notifications),
//           ),
//         ),
//       ),
//       Padding(
//         padding: EdgeInsets.only(top: paddingTop),
//         child: PopupMenuButton<int>(
//           icon: Container(
//             width: _width,
//             height: _height,
//             decoration: BoxDecoration(
//                 color: containerColor, borderRadius: BorderRadius.circular(10)),
//             child: const Icon(
//               Icons.more_vert,
//             ),
//           ),
//           onSelected: (int value) => onClick(value, context, screenSize),
//           itemBuilder: (context) {
//
//
//             return [
//               const PopupMenuItem<int>(
//                 value: 1,
//                 child: Text(
//                   'Settings',
//                   // style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//               const PopupMenuItem<int>(
//                 value: 2,
//                 child: Text(
//                   'Select',
//                   // style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//               ),
//               PopupMenuItem<int>(
//                 value: 3,
//                 child: syncType(context),
//               ),
//             ];
//           },
//         ),
//       ),
//     ],
//   );
// }




class HomeScreenAppbarActionWidget extends StatefulWidget {
  final double paddingTop;
   const HomeScreenAppbarActionWidget({required this.paddingTop, super.key});

  @override
  State<HomeScreenAppbarActionWidget> createState() => _HomeScreenAppbarActionWidgetState();
}

class _HomeScreenAppbarActionWidgetState extends State<HomeScreenAppbarActionWidget> {


  double width = 40;
  double height = 40;

  // if the UserNotesBox type is user or not : initialized with false (not user)
  bool typeUser = false;

  @override
  void initState() {
    Provider.of<NotesProvider>(context, listen: false).fetchUserNotes().then((userData) {
      print('future user data is available');
      if(userData['type'] == 'user') {
        setState(() {
          typeUser = true;
        });
      }
    });
    super.initState();
  }

  Widget syncType(BuildContext context) {
    return Selector<SyncProvider, SyncStatus>(
      selector: (context, syncProvider) => syncProvider.syncStatus,
      builder: (context, syncStatus, child) {
        switch (syncStatus) {
          case SyncStatus.syncFalse:
            return const Text('Sync');
          case SyncStatus.syncTrue:
            return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Sync',
                  style: TextStyle(color: Colors.green),
                ),
                Icon(Icons.check, color: Colors.green,),
              ],
            );
          case SyncStatus.notSynced:
            return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Not Synced',
                  style: TextStyle(color: Colors.red),
                ),
                Icon(Icons.cancel, color: Colors.red,),
              ],
            );
          case SyncStatus.synced:
            return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Synced',
                  style: TextStyle(color: Colors.green),
                ),
                Icon(Icons.check, color: Colors.green,),
              ],
            );
          default:
            return const Text('Sync');
        }
      },
    );
  }

  Future<void> _fetchRemoteNotesIfSynced() async {
    print('entered fetch remote note in appbar bar action');
    var userDetails = context.read<NotesProvider>().userDetails;
    print('user details in appbar action : $userDetails');
    if(userDetails == null) {
      throw Exception('user details could not be fetched from hive storage');
    }
    if(userDetails['isSynced'] == true) {
     await context.read<NotesProvider>().fetchRemoteNotes(context);
    }
  }

  void onClick(int value, BuildContext context, Size screenSize) async {
    if (value == 1) Navigator.of(context).pushNamed(SettingsScreen.routeName);
    if (value == 2) {
      scaffoldMessage(
          message: 'Feature coming soon...',
          context: context,
          screenSize: screenSize);
    }
    if (value == 3) {
      await Provider.of<NotesProvider>(context, listen: false).toggleSync();
      await context.read<SyncProvider>().updateSyncInFirestore(context);
      await _fetchRemoteNotesIfSynced();

    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Color containerColor = Theme.of(context).colorScheme.surface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.only(top: widget.paddingTop),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: containerColor, borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () => scaffoldMessage(
                  message: 'Feature coming soon...',
                  context: context,
                  screenSize: screenSize),
              icon: const Icon(Icons.notifications),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: widget.paddingTop),
          child: PopupMenuButton<int>(
            icon: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  color: containerColor, borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.more_vert,
              ),
            ),
            onSelected: (int value) => onClick(value, context, screenSize),
            itemBuilder: (context) {
print('pop up buttons have been created');

              return [
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text(
                    'Settings',
                    // style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text(
                    'Select',
                    // style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if(typeUser)
                PopupMenuItem<int>(
                  value: 3,
                  child: syncType(context),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}

