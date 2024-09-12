import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/system_theme.dart';
import 'package:task_management/common/themes.dart';
import 'package:task_management/network/data/notes/notes_provider.dart';
import 'package:task_management/network/data/theme_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
import 'package:task_management/network/models/loginInfo.dart';
import 'package:task_management/screens/authentication/login_page.dart';
import 'package:task_management/screens/homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  // var box = await Hive.openBox<NoteModel>('NoteModelBox');
  // box.clear();
  // print('box : ${box.length}');
  // NoteModel dummyNote = NoteModel(title: 'name', note: 'ashish lahre', bookmarked: false);
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
        ChangeNotifierProvider(create: (context) => LoginInfoProvider()),
      ],
      child: const SystemTheme(child: MyApp()),
    ),
  );
}

Future<Widget> AuthenticateUser(BuildContext context) async {
  bool exists = await LoginInfoRepository.checkLoginInfoBoxExists();
  if(exists) {

      LoginInfo loginInfo = Provider.of<LoginInfoProvider>(context).loginInfo;
      if(loginInfo.type == 'user') {

        var isConnected = await InternetConnectionChecker().hasConnection;
        if(isConnected) {
            //TODO: Check logged in with firebase
          return const HomeScreen();



        } else {
          // logged in as a user but not connected to internet
          // TODO: HEADER --> Offline Mode
          return const HomeScreen();
        }

      } else {
        // type - Guest
        return const HomeScreen();

      }
  } else {
    // TODO: Clear all notes already exists in local device
      return const SignInScreen();
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: context.watch<ThemeProvider>().themeMode,
      // ThemeData(
      //
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: HomeScreen(),
    );
  }
}

// Reformat file = ctrl + alt + L
