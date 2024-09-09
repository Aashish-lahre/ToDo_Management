import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:task_management/common/system_theme.dart';
import 'package:task_management/common/themes.dart';
import 'package:task_management/network/data/notes_provider.dart';
import 'package:task_management/network/data/theme_provider.dart';
import 'package:task_management/network/models/NoteModel.dart';
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

  // final Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  //
  // // Set the system UI overlay style based on the brightness
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: brightness == Brightness.dark
  //       ? Color(0xFF2f3136) // Dark mode color
  //       : Color(0xFFe9ecef), // Light mode color
  //   statusBarIconBrightness: brightness == Brightness.dark
  //       ? Brightness.light // Light icons for dark mode
  //       : Brightness.dark,  // Dark icons for light mode
  // ));
  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (context) => ThemeProvider(),),

        ChangeNotifierProvider(
          create: (context) => NotesProvider(),

        ),
      ],
      child: const SystemTheme(child: MyApp()),
    ),
  );
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
