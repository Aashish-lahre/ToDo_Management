import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/system_theme.dart';
import 'package:task_management/common/themes.dart';
import 'package:task_management/network/data/header_loading_provider.dart';
import 'package:task_management/network/data/header_message_provider.dart';
import 'package:task_management/network/data/note_detail_screen_provider.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/data/sync_provider.dart';
import 'package:task_management/network/data/theme_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/screens/add_note_screen.dart';
import 'package:task_management/screens/authentication/login_page.dart';
import 'package:task_management/screens/authentication/sign_up_page.dart';
import 'package:task_management/screens/homeScreen.dart';
import 'package:task_management/screens/note_detail_screen.dart';
import 'package:task_management/screens/profile.dart';
import 'package:task_management/screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  await Firebase.initializeApp();
  // var box = await Hive.openBox<dynamic>('LoginInfoBox');
  // box.deleteFromDisk();
  // if(await Hive.boxExists('NoteModelBox')) {
  //   print('map box exists in main');
  //   var notes = await Hive.openBox<Map<String, Object>>('NoteModelBox');
  //   await notes.deleteFromDisk();
  //   print('deleted the box in main');
  // }
  //
  // if(await Hive.boxExists('NoteModelBox')) {
  //   print('dynamic box exists in main');
  //   var notes = await Hive.openBox<dynamic>('NoteModelBox');
  //   notes.deleteFromDisk();
  // }

  // print('box : ${box.length}');
  // NoteModel dummyNote = NoteModel(title: 'name', note: 'ashish', bookmarked: false);
  // var box = await Hive.openBox<NoteModel>('NoteModelBox');
  // box.add(dummyNote);
  // print('local stored value : ${box.values.last.note}');


  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (context) => ThemeProvider(),),

        ChangeNotifierProvider(
          create: (context) => NotesProvider(),

        ),
        
        ChangeNotifierProxyProvider<NotesProvider, SyncProvider>(
          create: (context) => SyncProvider(),
          update: (context, notesProvider, syncProvider) => (syncProvider ?? SyncProvider())..updateIsSynced(notesProvider.isSynced),
        ),

        ChangeNotifierProvider(create: (context) => NoteDetailScreenProvider()),

        ChangeNotifierProvider(create: (context) => HeaderMessageProvider()),

        ChangeNotifierProvider(create: (context) => HeaderLoadingProvider()),

      ],
      child: const SystemTheme(child: MyApp()),
    ),
  );
}

// Future<Widget> AuthenticateUser(BuildContext context) async {
//   bool exists = await LoginInfoRepository.checkLoginInfoBoxExists();
//   if(exists) {
//       print('login info exists');
//       LoginInfo loginInfo = Provider.of<LoginInfoProvider>(context, listen: false).loginInfo;
//       print("loginInfo : $loginInfo");
//       if(loginInfo.type == 'user') {
//         print('login info type user');
//         var isConnected = await InternetConnectionChecker().hasConnection;
//         if(isConnected) {
//             //TODO: Check logged in with firebase
//           User? user = FirebaseAuth.instance.currentUser;
//
//           if(user != null) {
//             print('user is not null');
//             return const HomeScreen();
//           } else {
//             var auth = FirebaseAuth.instance;
//             try {
//               UserCredential userCredential = await auth.signInWithEmailAndPassword(
//                 email: loginInfo.email!.trim(),
//                 password: loginInfo.password!.trim(),
//               );
//
//               // If login is successful, navigate to the home screen
//               if (userCredential.user != null) {
//                 return const HomeScreen();
//               } else {
//                 // login did not successful
//                 return const HomeScreen();
//               }
//             } on FirebaseAuthException catch (e) {
//               if(e.code == 'user-not-found') {
//                 // message -> Account has been deleted
//                 // log in as a guest and transfer all notes.
//                   Provider.of<LoginInfoProvider>(context, listen: false).createLoginInfo(LoginInfo.guest(isSynced: false));
//                   Provider.of<NotesProvider>(context, listen: false).changeAccountType('guest');
//
//                   return const HomeScreen();
//
//               } else if(e.code == "network-request-failed") {
//               //       message -> connection is slow, can't sync with cloud
//                 return const HomeScreen();
//               } else {
//                 // unknown state
//                 return const HomeScreen();
//               }
//             }  catch (e) {
//               // Handle any other errors
//               // show the message
//               return const HomeScreen();
//
//             }
//           }
//
//
//
//
//
//         } else {
//           // logged in as a user but not connected to internet
//           // TODO: HEADER --> Offline Mode
//           return const HomeScreen();
//         }
//
//       } else {
//         // type - Guest
//         return const HomeScreen();
//
//       }
//   } else {
//     // TODO: Clear all notes already exists in local device
//     print('login info does not exists');
//     await Provider.of<NotesProvider>(context, listen: false).deleteAllNote();
//       return const SignInScreen();
//   }
// }



class MyApp extends StatefulWidget {
  const MyApp({super.key});
  // static const routeName = '/';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NotesProvider>(context, listen: false).initialiseData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading screen while waiting for the future to complete
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error

          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error loading data: ${snapshot.error}')),
            ),
          );
        } else {
          // Data initialization is complete, proceed with the app

          if(snapshot.hasData) {
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {

                    await context.read<NotesProvider>().fetchRemoteNotes(context);



              });
            }
          }

          return
            // MaterialApp(home: Center(child: Text('worked'),));

            MaterialApp(
            // initialRoute: '/homeScreen',
            routes: {
              '/homeScreen': (context) => const HomeScreen(),
              '/signIn': (context) => const SignInScreen(),
              '/signUp': (context) => const SignUpScreen(),
              '/addNoteScreen': (context) => const AddNoteScreen(),
              '/noteDetailScreen': (context) => const NoteDetailScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
            title: 'Notes',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
            context.watch<ThemeProvider>().themeMode,
              home: const HomeScreen(),
          );
        }
      },
    );
  }
}


// Reformat file = ctrl + alt + L
